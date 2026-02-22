import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class RayosXDetailScreen extends ConsumerWidget {
  final String nombre;
  final String fecha;

  const RayosXDetailScreen({super.key, required this.nombre, required this.fecha});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'resumen': 'Resumen del estudio',
        'descargar': 'Descargar imagen/PDF'
      },
      'en': {
        'resumen': 'Study summary',
        'descargar': 'Download image/PDF'
      }
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header fijo con flecha, logo y selector idioma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF003DA5)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/icons/logo.jpg', height: 50),
                  DropdownButton<String>(
                    value: lang,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'es', child: Text('ES 🇲🇽')),
                      DropdownMenuItem(value: 'en', child: Text('EN 🇺🇸')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(languageProvider.notifier).state = value;
                      }
                    },
                  ),
                ],
              ),
            ),

            // Contenido con scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5)),
                    ),
                    const SizedBox(height: 10),
                    Text(fecha, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 20),
                    Text(
                      textos[lang]!['resumen']!,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lang == 'es'
                          ? "Este estudio muestra la radiografía solicitada. Los valores son normales."
                          : "This study shows the requested X-Ray. Values are normal.",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 300), // simula contenido largo
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Footer fijo con botón descargar
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
          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
          label: Text(textos[lang]!['descargar']!,
              style: const TextStyle(color: Colors.white)),
          onPressed: () {
            // TODO: lógica para descargar imagen o PDF
          },
        ),
      ),
    );
  }
}
