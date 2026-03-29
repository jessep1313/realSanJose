import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class AgendarScreen extends ConsumerStatefulWidget {
  const AgendarScreen({super.key});

  @override
  ConsumerState<AgendarScreen> createState() => _AgendarScreenState();
}

class _AgendarScreenState extends ConsumerState<AgendarScreen> {
  String? tipoCita;
  DateTime? selectedDay;
  String? horarioSeleccionado;

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Agendar cita',
        'desc': 'Selecciona tipo de cita, fecha y horario',
        'tipo': 'Tipo de cita',
        'horarios': 'Horarios disponibles',
        'agendar': 'Agendar'
      },
      'en': {
        'title': 'Book appointment',
        'desc': 'Select type, date and time',
        'tipo': 'Appointment type',
        'horarios': 'Available times',
        'agendar': 'Book'
      }
    };

    // ⭐ OPCIONES ACTUALIZADAS
    final tipos = {
      'es': ['Consulta Médica', 'Rayos X', 'Laboratorio'],
      'en': ['Medical Consultation', 'X-Rays', 'Laboratory']
    };

    final horarios = [
      "08:00 AM",
      "09:00 AM",
      "10:00 AM",
      "11:00 AM",
      "12:00 PM"
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

                    // ⭐ DROPDOWN PREMIUM ANCHO COMPLETO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF003DA5),
                          width: 2,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: tipoCita,
                          hint: Text(
                            textos[lang]!['tipo']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          items: tipos[lang]!
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => tipoCita = value);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Calendario
                    CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      onDateChanged: (date) {
                        setState(() => selectedDay = date);
                      },
                    ),

                    // Horarios disponibles
                    Text(
                      textos[lang]!['horarios']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5),
                      ),
                    ),

                    Wrap(
                      spacing: 10,
                      children: horarios.map((h) {
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

      // Footer con botón
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
}
