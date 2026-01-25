import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/custom_header.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class RayosXScreen extends ConsumerWidget {
  const RayosXScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final textos = {
      'es': {'title': 'Rayos X', 'desc': 'Visualiza tus estudios de imagen'},
      'en': {'title': 'X-Rays', 'desc': 'View your imaging studies'},
    };

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
                  Icon(Icons.image, size: 100, color: Color(0xFF009639)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
