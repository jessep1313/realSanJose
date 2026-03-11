import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class MaternidadScreen extends ConsumerWidget {
  const MaternidadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final t = {
      'es': {
        'login': 'Iniciar sesión',
        'title': 'Maternidad',
        'intro': 'Estamos contigo desde el primer momento',

        // Secciones de la imagen
        'piso_title': 'Piso exclusivo de maternidad',
        'piso_text': 'Que nada interrumpa tu tranquilidad y felicidad.\n'
            'Con nuestros pisos exclusivos de maternidad, enfócate en tu recuperación y la bienvenida de tu bebé.\n'
            '¡Te sentirás tan cómoda que casi olvidarás que estás en un hospital!',

        'wellness_title': 'Ambiente Wellness',
        'wellness_text':
            'Contamos con habitaciones suites que permiten la colocación de tu decoración y candy bar para la recepción de tus familiares.\n'
                'Proporcionando un espacio wellness para el paciente, familia y amigos.',

        'alojamiento_title': 'Alojamiento conjunto',
        'alojamiento_text':
            'Si así lo decides, contamos con la opción de que tu bebé permanezca contigo en la habitación bajo supervisión constante de nuestras enfermeras.',

        // Tecnología
        'tec_title': 'Tecnología de Vanguardia',
        'seguridad_title': 'Seguridad Integral para tu bebé',
        'seguridad_text':
            'Nuestro Hospital cuenta con un Sistema de Seguridad Integral para su Bebé, a través de un brazalete con chip llamado Baby Match.\n\n'
                'Funciona monitoreando la ubicación de su bebé en tiempo real mientras notifica un posible robo, error de coincidencia y/o eventos de intercambio.\n\n'
                'Inmediatamente después del nacimiento, los chips son colocados tanto a la madre como al bebé.',
      },

      // ------------------ ENGLISH VERSION ------------------
      'en': {
        'login': 'Sign in',
        'title': 'Maternity',
        'intro': 'We are with you from the very first moment',
        'piso_title': 'Exclusive Maternity Floor',
        'piso_text': 'Let nothing interrupt your peace and happiness.\n'
            'With our exclusive maternity floors, focus on your recovery and welcoming your baby.\n'
            'You will feel so comfortable that you may forget you are in a hospital!',
        'wellness_title': 'Wellness Environment',
        'wellness_text':
            'We offer suite rooms that allow decoration and candy bar setups for your family’s reception.\n'
                'Providing a wellness space for the patient, family, and friends.',
        'alojamiento_title': 'Rooming-in',
        'alojamiento_text':
            'If you choose, your baby may stay with you in the room under constant supervision from our nurses.',
        'tec_title': 'Cutting-edge Technology',
        'seguridad_title': 'Comprehensive Baby Safety',
        'seguridad_text':
            'Our hospital uses an integral baby safety system through a chip bracelet called Baby Match.\n\n'
                'It monitors your baby’s location in real time and alerts for possible theft, mismatch, or exchange events.\n\n'
                'Immediately after birth, chips are placed on both the mother and the baby.',
      }
    };

    final sections = [
      {
        'img': 'piso_maternidad.avif',
        'title': 'piso_title',
        'text': 'piso_text',
      },
      {
        'img': 'wellness.avif',
        'title': 'wellness_title',
        'text': 'wellness_text',
      },
      {
        'img': 'alojamiento.avif',
        'title': 'alojamiento_title',
        'text': 'alojamiento_text',
      },
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

            // Intro
            Text(
              t[lang]!['intro']!,
              style: const TextStyle(fontSize: 18, height: 1.4),
            ),

            const SizedBox(height: 30),

            // ---------------------- SECCIONES DE LA IMAGEN ----------------------
            ...sections.map((s) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/${s['img']}',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Título
                  Text(
                    t[lang]![s['title']]!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009639),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Texto
                  Text(
                    t[lang]![s['text']]!,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),

                  const SizedBox(height: 30),
                ],
              );
            }),

            // ---------------------- TECNOLOGÍA ----------------------
            Text(
              t[lang]!['tec_title']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              t[lang]!['seguridad_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              t[lang]!['seguridad_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
