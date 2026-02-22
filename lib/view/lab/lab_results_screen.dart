import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'lab_result_detail_screen.dart'; // 👈 importamos la pantalla de detalle

class LabResultsScreen extends ConsumerWidget {
  const LabResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Resultados de laboratorio', 'desc': 'Consulta tus análisis clínicos'},
      'en': {'title': 'Lab results', 'desc': 'Check your clinical tests'},
    };

    final resultados = [
      {"nombre": lang == 'es' ? "Biometría Hemática" : "Blood Count", "fecha": "12/01/2026"},
      {"nombre": lang == 'es' ? "Química sanguínea" : "Blood Chemistry", "fecha": "05/01/2026"},
      {"nombre": lang == 'es' ? "Perfil lipídico" : "Lipid Profile", "fecha": "20/12/2025"},
    ];

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
                ],
              ),
            ),

            // Listado con scroll independiente
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final r = resultados[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.biotech, color: Color(0xFF009639)),
                      title: Text(r["nombre"]!),
                      subtitle: Text(r["fecha"]!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LabResultDetailScreen(
                              nombre: r["nombre"]!,
                              fecha: r["fecha"]!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
