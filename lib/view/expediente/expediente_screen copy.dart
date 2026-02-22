import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';


class ExpedienteScreen extends ConsumerWidget {
  const ExpedienteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Expediente médico', 'desc': 'Consulta tu historial clínico completo'},
      'en': {'title': 'Medical record', 'desc': 'Check your full medical history'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Expediente"),
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
                  Icon(Icons.folder_shared, size: 100, color: Color(0xFF009639)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
