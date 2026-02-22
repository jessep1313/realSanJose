import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class ServiciosScreen extends ConsumerWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final t = {
      'es': {
        'login': 'Iniciar sesión',
        'title': 'Servicios Médicos',
        'urgencias': 'Urgencias',
        'adulto': 'Terapia Intensiva e Intermedia para Adulto',
        'neonatal': 'Terapia Intensiva e Intermedia Neonatal y Pediátrica',
        'cuneros': 'Cuneros',
        'resonancia': 'Resonancia Magnética',
        'eco': 'Ecocardiograma IE33',
        'ultra': 'Ultrasonido Doppler IE22',
        'consulta': 'Consulta General',
        'mamografia': 'Mamografía Digitalizada',
        'fluoro': 'Fluoroscopia',
        'chequeos': 'Chequeos Médicos',
        'hemodinamia': 'Sala de Hemodinamia',
      },
      'en': {
        'login': 'Sign in',
        'title': 'Medical Services',
        'urgencias': 'Emergency Care',
        'adulto': 'Adult Intensive & Intermediate Care',
        'neonatal': 'Neonatal & Pediatric Intensive Care',
        'cuneros': 'Nursery',
        'resonancia': 'Magnetic Resonance Imaging (MRI)',
        'eco': 'Echocardiogram IE33',
        'ultra': 'Doppler Ultrasound IE22',
        'consulta': 'General Consultation',
        'mamografia': 'Digital Mammography',
        'fluoro': 'Fluoroscopy',
        'chequeos': 'Medical Checkups',
        'hemodinamia': 'Hemodynamics Room',
      }
    };

    final servicios = [
      'urgencias',
      'adulto',
      'neonatal',
      'cuneros',
      'resonancia',
      'eco',
      'ultra',
      'consulta',
      'mamografia',
      'fluoro',
      'chequeos',
      'hemodinamia',
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------------- HEADER ----------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 60,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flecha de regresar
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF003DA5)),
                onPressed: () => Navigator.pop(context),
              ),

              // Iniciar sesión con icono
              InkWell(
                onTap: () => context.push(LoginScreen.routeName),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline,
                        size: 22, color: Color(0xFF003DA5)),
                    const SizedBox(width: 6),
                    Text(
                      t[lang]!['login']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003DA5),
                      ),
                    ),
                  ],
                ),
              ),

              // Selector de idioma
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
      ),

      // ---------------------- CONTENIDO ----------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              t[lang]!['title']!,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),

            const SizedBox(height: 20),

            // LISTA DE SERVICIOS
            ...servicios.map((key) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título del servicio
                  Text(
                    t[lang]![key]!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009639),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Espacio para imagen
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/$key.avif',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),


                  const SizedBox(height: 30),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
