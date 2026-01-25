import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/custom_header.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class AgendarScreen extends ConsumerWidget {
  const AgendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Agendar cita', 'desc': 'Selecciona fecha y especialidad'},
      'en': {'title': 'Book appointment', 'desc': 'Select date and specialty'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Agendar"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    textos[lang]!['title']!,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textos[lang]!['desc']!,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009639),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: Text(textos[lang]!['title']!,
                        style: const TextStyle(color: Colors.white)),
                    onPressed: () {
                      // TODO: lógica para agendar cita
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
