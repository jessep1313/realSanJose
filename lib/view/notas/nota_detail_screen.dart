import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class NotaDetailScreen extends ConsumerWidget {
  final String titulo;
  final String autor;
  final String fecha;

  const NotaDetailScreen({super.key, required this.titulo, required this.autor, required this.fecha});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {'resumen': 'Detalle de la nota médica'},
      'en': {'resumen': 'Medical note detail'},
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
                      titulo,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003DA5)),
                    ),
                    const SizedBox(height: 10),
                    Text("$autor - $fecha", style: const TextStyle(color: Colors.black54)),
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
                          ? "El paciente presenta evolución favorable. Se recomienda continuar con el tratamiento indicado."
                          : "The patient shows favorable progress. It is recommended to continue the prescribed treatment.",
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
    );
  }
}

