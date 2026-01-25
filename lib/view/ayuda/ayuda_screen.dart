import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/custom_header.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class AyudaScreen extends ConsumerWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Ayuda',
        'desc': 'Encuentra respuestas y soporte',
        'faq': 'Preguntas frecuentes',
        'contacto': 'Contactar soporte',
        'manual': 'Manual de usuario',
      },
      'en': {
        'title': 'Help',
        'desc': 'Find answers and support',
        'faq': 'Frequently Asked Questions',
        'contacto': 'Contact support',
        'manual': 'User manual',
      }
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(title: "Ayuda"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  // Opciones de ayuda
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.help_outline,
                          color: Color(0xFF009639)),
                      title: Text(textos[lang]!['faq']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: abrir sección de FAQ
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.support_agent,
                          color: Color(0xFF009639)),
                      title: Text(textos[lang]!['contacto']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: abrir contacto de soporte
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.menu_book,
                          color: Color(0xFF009639)),
                      title: Text(textos[lang]!['manual']!),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: abrir manual de usuario
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
