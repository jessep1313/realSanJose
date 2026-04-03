import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/api/auth_service.dart';

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
  String? horarioSeleccionado;

  List<Map<String, dynamic>> catalogoEstudios = [];
  bool cargandoCatalogo = false;

  List<String> horariosDisponibles = [];
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
    if (estudioSeleccionado == null || hospitalSeleccionado == null) return;

    setState(() {
      cargandoHorarios = true;
      horariosDisponibles = [];
    });

    final service = AuthService();

    try {
      final lista = await service.fetchAgendaDisponible(
        estudioSeleccionado!,
        hospitalSeleccionado!,
      );

      setState(() {
        horariosDisponibles = lista;
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
        'desc': 'Selecciona tipo de cita, hospital, estudio, fecha y horario',
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
        'desc': 'Select type, hospital, study, date and time',
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
                    Text(
                      textos[lang]!['title']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      textos[lang]!['desc']!,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
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
                        });

                        if (value == 1 || value == 2) {
                          cargarCatalogo(value);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // ⭐ HOSPITAL
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
                          });

                          if (estudioSeleccionado != null) {
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
                                    color: Color(0xFF003DA5),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(textos[lang]!['loading']!),
                              ],
                            )
                          else if (catalogoEstudios.isNotEmpty)
                            _buildDropdown(
                              label: "",
                              value: estudioSeleccionado,
                              items: catalogoEstudios
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e["id"],
                                      child: Text(e["descripcion"].toString()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  estudioSeleccionado = value;
                                  horariosDisponibles = [];
                                });
                                cargarHorarios();
                              },
                            ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    // ⭐ CALENDARIO
                    CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      onDateChanged: (date) {
                        setState(() => selectedDay = date);
                      },
                    ),

                    const SizedBox(height: 20),

                    // ⭐ HORARIOS DISPONIBLES
                    Text(
                      textos[lang]!['horarios']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5),
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (cargandoHorarios)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: Color(0xFF003DA5),
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
                        children: horariosDisponibles.map((h) {
                          final selected = horarioSeleccionado == h;
                          return ChoiceChip(
                            label: Text(h),
                            selected: selected,
                            selectedColor: const Color(0xFF003DA5),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                            ),
                            onSelected: (_) {
                              setState(() => horarioSeleccionado = h);
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
            backgroundColor: const Color(0xFF009639),
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
          onPressed: () {
            if (tipoCita != null &&
                hospitalSeleccionado != null &&
                estudioSeleccionado != null &&
                selectedDay != null &&
                horarioSeleccionado != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'es'
                        ? "Cita agendada correctamente"
                        : "Appointment booked successfully",
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'es'
                        ? "Completa todos los campos"
                        : "Please complete all fields",
                  ),
                ),
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
            border: Border.all(color: Color(0xFF003DA5), width: 2),
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
