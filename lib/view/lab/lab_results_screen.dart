import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/custom_header.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class LabResultsScreen extends ConsumerWidget {
  const LabResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Resultados de laboratorio', 'desc': 'Consulta tus análisis clínicos'},
      'en': {'title': 'Lab results', 'desc': 'Check your clinical tests'},
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Lab"),
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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.biotech, color: Color(0xFF009639)),
                      title: Text(lang == 'es' ? "Biometría Hemática" : "Blood Count"),
                      subtitle: Text("12/01/2026"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: abrir detalle de resultado
                      },
                    ),
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
