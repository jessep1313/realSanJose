import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class EspecialidadesScreen extends ConsumerWidget {
  const EspecialidadesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final t = {
      'es': {
        'login': 'Iniciar sesión',
        'title': 'Especialidades',
        'intro':
            'Unidades de alta especialidad\n'
                'Hospital Real San José | Valle Real se preocupa por estar a la vanguardia en todos los aspectos, '
                'por lo que aquí podrás conocer más de nuestros servicios bajo tecnología de vanguardia.',
        'gine': 'GINECOLOGÍA / OBSTETRICIA',
        'plast': 'CIRUGÍA PLÁSTICA',
        'general': 'CIRUGÍA GENERAL',
        'oto': 'OTORRINOLARINGOLOGÍA',
        'uro': 'UROLOGÍA',
        'gastro': 'GASTROENTEROLOGÍA',
        'neuro': 'NEUROLOGÍA',
        'cardio': 'CARDIOLOGÍA',
        'procto': 'PROCTOLOGÍA',
        'onco': 'ONCOLOGÍA',
        'nefro': 'NEFROLOGÍA',
      },
      'en': {
        'login': 'Sign in',
        'title': 'Specialties',
        'intro':
            'High Specialty Units\n'
                'Hospital Real San José | Valle Real is committed to staying at the forefront in every aspect, '
                'offering advanced medical services supported by cutting-edge technology.',
        'gine': 'GYNECOLOGY / OBSTETRICS',
        'plast': 'PLASTIC SURGERY',
        'general': 'GENERAL SURGERY',
        'oto': 'OTORHINOLARYNGOLOGY',
        'uro': 'UROLOGY',
        'gastro': 'GASTROENTEROLOGY',
        'neuro': 'NEUROLOGY',
        'cardio': 'CARDIOLOGY',
        'procto': 'PROCTOLOGY',
        'onco': 'ONCOLOGY',
        'nefro': 'NEPHROLOGY',
      }
    };

    final especialidades = [
      'gine',
      'plast',
      'general',
      'oto',
      'uro',
      'gastro',
      'neuro',
      'cardio',
      'procto',
      'onco',
      'nefro',
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

            // Texto introductorio
            Text(
              t[lang]!['intro']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 30),

            // LISTA DE ESPECIALIDADES
            ...especialidades.map((key) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de la especialidad
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
