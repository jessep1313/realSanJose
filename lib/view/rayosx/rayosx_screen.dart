import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/common/widget/custom_header.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'rayosx_detail_screen.dart'; // 👈 importamos la pantalla de detalle

class RayosXScreen extends ConsumerWidget {
  const RayosXScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Rayos X', 'desc': 'Visualiza tus estudios de imagen'},
      'en': {'title': 'X-Rays', 'desc': 'View your imaging studies'},
    };

    final estudios = [
      {"nombre": lang == 'es' ? "Radiografía de tórax" : "Chest X-Ray", "fecha": "15/01/2026"},
      {"nombre": lang == 'es' ? "Radiografía de rodilla" : "Knee X-Ray", "fecha": "10/01/2026"},
      {"nombre": lang == 'es' ? "Radiografía dental" : "Dental X-Ray", "fecha": "05/01/2026"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Rayos X"),
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
                ],
              ),
            ),

            // Listado con scroll independiente
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: estudios.length,
                itemBuilder: (context, index) {
                  final e = estudios[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.image, color: Color(0xFF009639)),
                      title: Text(e["nombre"]!),
                      subtitle: Text(e["fecha"]!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RayosXDetailScreen(
                              nombre: e["nombre"]!,
                              fecha: e["fecha"]!,
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
