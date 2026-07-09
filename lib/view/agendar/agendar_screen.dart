import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AgendarScreen extends ConsumerStatefulWidget {
  const AgendarScreen({super.key});

  @override
  ConsumerState<AgendarScreen> createState() => _AgendarScreenState();
}

class _AgendarScreenState extends ConsumerState<AgendarScreen> {
  int? tipoCita; // 0 = consulta, 1 = RX, 2 = LAB
  int? hospitalSeleccionado;
  int? estudioSeleccionado;

  DateTime? selectedDay;
  DateTime? horarioSeleccionado; // Ahora guarda DateTime local

  List<Map<String, dynamic>> catalogoEstudios = [];
  bool cargandoCatalogo = false;

  List<DateTime> horariosDisponibles = []; // Ahora lista de DateTime
  bool cargandoHorarios = false;

  String? lastLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = ref.watch(languageProvider);
    if (lastLang != lang) {
      lastLang = lang;
      tipoCita = null;
      hospitalSeleccionado = null;
      estudioSeleccionado = null;
      catalogoEstudios = [];
      horariosDisponibles = [];
      horarioSeleccionado = null;
    }
  }

  // ⭐ Cargar catálogo RX/LAB
  Future<void> cargarCatalogo(int tipo) async {
    setState(() {
      cargandoCatalogo = true;
      catalogoEstudios = [];
      estudioSeleccionado = null;
    });

    final service = AuthService();
    List<Map<String, dynamic>> lista = [];

    if (tipo == 1) {
      lista = await service.fetchRx();
    } else if (tipo == 2) {
      lista = await service.fetchLab();
    }

    setState(() {
      catalogoEstudios = lista;
      cargandoCatalogo = false;
    });
  }

  // ⭐ Cargar horarios disponibles desde API
  Future<void> cargarHorarios() async {
    if (estudioSeleccionado == null ||
        hospitalSeleccionado == null ||
        selectedDay == null) return;

    setState(() {
      cargandoHorarios = true;
      horariosDisponibles = [];
      horarioSeleccionado = null;
    });

    final service = AuthService();

    try {
      final lista = await service.fetchAgendaDisponible(
        estudioSeleccionado!,
        hospitalSeleccionado!,
        selectedDay!,
      );

      // Convertir cada string UTC a DateTime local
      setState(() {
        horariosDisponibles =
            lista.map((s) => DateTime.parse(s).toLocal()).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando horarios: $e")),
      );
    } finally {
      setState(() => cargandoHorarios = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Agendar cita',
        'desc': 'Selecciona fecha, tipo de cita, hospital, estudio y horario',
        'tipo': 'Tipo de cita',
        'hospital': 'Selecciona hospital',
        'estudio': 'Selecciona estudio',
        'horarios': 'Horarios disponibles',
        'agendar': 'Agendar',
        'consulta': 'Consulta Médica',
        'rx': 'Rayos X',
        'lab': 'Laboratorio',
        'loading': 'Cargando catálogo...',
      },
      'en': {
        'title': 'Book appointment',
        'desc': 'Select date, type, hospital, study and time',
        'tipo': 'Appointment type',
        'hospital': 'Select hospital',
        'estudio': 'Select study',
        'horarios': 'Available times',
        'agendar': 'Book',
        'consulta': 'Medical Consultation',
        'rx': 'X-Rays',
        'lab': 'Laboratory',
        'loading': 'Loading catalog...',
      }
    };

    final hospitales = [
      {"id": 0, "nombre": "Hospital Lázaro Cárdenas"},
      {"id": 1, "nombre": "Hospital Valle Real"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Agendar"),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y descripción
                    Text(
                      textos[lang]!['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0166B8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textos[lang]!['desc']!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // ⭐ CALENDARIO (PRIMERO)
                    CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 7)), // ⬅️ Límite 7 días
                      onDateChanged: (date) {
                        setState(() {
                          selectedDay = date;
                          horariosDisponibles = [];
                          horarioSeleccionado = null;
                        });
                        // Si ya hay estudio y hospital, recargar horarios
                        if (estudioSeleccionado != null &&
                            hospitalSeleccionado != null) {
                          cargarHorarios();
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // ⭐ TIPO DE CITA
                    _buildDropdown(
                      label: textos[lang]!['tipo']!,
                      value: tipoCita,
                      items: [
                        DropdownMenuItem(
                            value: 0, child: Text(textos[lang]!['consulta']!)),
                        DropdownMenuItem(
                            value: 1, child: Text(textos[lang]!['rx']!)),
                        DropdownMenuItem(
                            value: 2, child: Text(textos[lang]!['lab']!)),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoCita = value;
                          hospitalSeleccionado = null;
                          estudioSeleccionado = null;
                          catalogoEstudios = [];
                          horariosDisponibles = [];
                          horarioSeleccionado = null;
                        });

                        if (value == 1 || value == 2) {
                          cargarCatalogo(value);
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // ⭐ HOSPITAL (si tipo cita seleccionado)
                    if (tipoCita != null)
                      _buildDropdown(
                        label: textos[lang]!['hospital']!,
                        value: hospitalSeleccionado,
                        items: hospitales
                            .map((h) => DropdownMenuItem(
                                  value: h["id"],
                                  child: Text(h["nombre"].toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            hospitalSeleccionado = value;
                            horariosDisponibles = [];
                            horarioSeleccionado = null;
                          });
                          // Si ya hay estudio y fecha, cargar horarios
                          if (estudioSeleccionado != null &&
                              selectedDay != null) {
                            cargarHorarios();
                          }
                        },
                      ),
                    const SizedBox(height: 20),

                    // ⭐ ESTUDIOS (RX / LAB)
                    if (tipoCita == 1 || tipoCita == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textos[lang]!['estudio']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (cargandoCatalogo)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF0166B8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(textos[lang]!['loading']!),
                              ],
                            )
                          else if (catalogoEstudios.isNotEmpty)
                            DropdownSearch<Map<String, dynamic>>(
                              items: catalogoEstudios,
                              itemAsString: (e) => e["descripcion"].toString(),
                              selectedItem: estudioSeleccionado == null
                                  ? null
                                  : catalogoEstudios.firstWhere(
                                      (e) => e["id"] == estudioSeleccionado,
                                      orElse: () => <String, dynamic>{},
                                    ),
                              onChanged: (value) {
                                setState(() {
                                  estudioSeleccionado = value?["id"];
                                  horariosDisponibles = [];
                                  horarioSeleccionado = null;
                                });
                                if (hospitalSeleccionado != null &&
                                    selectedDay != null) {
                                  cargarHorarios();
                                }
                              },
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: textos[lang]!['estudio']!,
                                  hintText: lang == 'es'
                                      ? 'Selecciona estudio'
                                      : 'Select study', // 🔹 placeholder
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              popupProps: const PopupProps.menu(
                                showSearchBox: true,
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 20),

                    // ⭐ HORARIOS DISPONIBLES
                    Text(
                      textos[lang]!['horarios']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0166B8),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (cargandoHorarios)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Color(0xFF0166B8),
                          ),
                        ),
                      )
                    else if (horariosDisponibles.isEmpty)
                      Text(
                        lang == 'es'
                            ? "No hay horarios disponibles"
                            : "No available times",
                        style: const TextStyle(color: Colors.red),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: horariosDisponibles.map((horaLocal) {
                          // Formatear solo HH:mm para mostrar
                          final horaStr =
                              "${horaLocal.hour.toString().padLeft(2, '0')}:${horaLocal.minute.toString().padLeft(2, '0')}";
                          final selected = horarioSeleccionado == horaLocal;

                          return ChoiceChip(
                            label: Text(horaStr),
                            selected: selected,
                            selectedColor: const Color(0xFF0166B8),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                            ),
                            onSelected: (_) {
                              setState(() {
                                horarioSeleccionado = horaLocal;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ⭐ BOTÓN FINAL
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B8E00),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.check, color: Colors.white),
          label: Text(
            textos[lang]!['agendar']!,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            if (tipoCita != null &&
                hospitalSeleccionado != null &&
                estudioSeleccionado != null &&
                selectedDay != null &&
                horarioSeleccionado != null) {
              try {
                final service = AuthService();
                String fechaStr_calendario =
                    selectedDay!.toString().split(' ')[0]; // "2026-06-30"

                // Formatear el DateTime local a ISO sin zona horaria

                final fechaHora =
                    "${fechaStr_calendario}T${horarioSeleccionado!.hour.toString().padLeft(2, '0')}:${horarioSeleccionado!.minute.toString().padLeft(2, '0')}:00";

                final result = await service.crearCita(
                  estudioId: estudioSeleccionado!,
                  sucursal: hospitalSeleccionado!,
                  fechaHora: fechaHora,
                );

                // Parsear fecha/hora para mostrar bonito
                final fechaHoraResult = DateTime.parse(result["FechaHora"]);
                final fechaStr =
                    "${fechaHoraResult.year}-${fechaHoraResult.month.toString().padLeft(2, '0')}-${fechaHoraResult.day.toString().padLeft(2, '0')}";
                final horaStr =
                    "${fechaHoraResult.hour.toString().padLeft(2, '0')}:${fechaHoraResult.minute.toString().padLeft(2, '0')}";

                // Mostrar modal con folio y fecha/hora
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Cita agendada"),
                    content: Text(
                        "Folio de la cita: ${result["FolioAgenda"]}\nFecha: $fechaStr a las $horaStr"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          // Limpiar campos y regresar al dashboard
                          setState(() {
                            tipoCita = null;
                            hospitalSeleccionado = null;
                            estudioSeleccionado = null;
                            selectedDay = null;
                            horarioSeleccionado = null;
                            catalogoEstudios = [];
                            horariosDisponibles = [];
                          });
                          Navigator.pushReplacementNamed(
                              context, "/dashboardscreen");
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al agendar cita: $e")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Completa todos los campos")),
              );
            }
          },
        ),
      ),
    );
  }

  // ⭐ WIDGET REUTILIZABLE PARA DROPDOWNS
  Widget _buildDropdown({
    required String label,
    required dynamic value,
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if (label.isNotEmpty) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF0166B8), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: value,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
