import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/custom_header.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class NotasScreen extends ConsumerWidget {
  const NotasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Notas médicas', 'desc': 'Revisa tus notas y diagnósticos'},
      'en': {'title': 'Medical notes', 'desc': 'Review your notes and diagnoses'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Notas"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(textos[lang]!['title']!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5))),
                  const SizedBox(height: 10),
                  Text(textos[lang]!['desc']!,
                      style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.description_outlined,
                        color: Color(0xFF009639)),
                    title: Text(lang == 'es' ? "Consulta general" : "General consultation"),
                    subtitle: Text("Dr. López - 20/01/2026"),
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
