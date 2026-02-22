import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class NosotrosScreen extends ConsumerWidget {
  const NosotrosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final t = {
      'es': {
        'login': 'Iniciar sesión',
        'title': 'Nosotros',
        'quienes': '¿Quiénes somos?',
        'quienes_text':
            "Somos un hospital certificado que brinda atención médico quirúrgica, "
                "soportados con tecnología de vanguardia, calidad y calidez humana.\n\n"
                "Gracias a nuestra estructura y diseño, somos reconocidos como un hospital "
                "inteligente con un innovador concepto de servicios de tipo hotelería.\n\n"
                "Estamos comprometidos a ofrecer una atención de calidad y seguridad a los "
                "pacientes, sus familiares y nuestros colaboradores, de manera oportuna, "
                "profesional y tecnológica, dentro de un entorno de calidez y trabajo en equipo, "
                "que garantice la satisfacción, cumpliendo sus requisitos e intentando exceder "
                "sus expectativas; siempre en apego a la legislación aplicable vigente, la "
                "sustentabilidad como empresa y un alto sentido de responsabilidad social, "
                "mejorando continuamente la eficacia de nuestro Sistema de Gestión de la Calidad.",
        'mision_vision': 'Misión y Visión',
        'mision':
            "MISIÓN\nAsegurar que Pacientes, Familia y Médicos estén en las “Mejores Manos”, "
                "con procesos de calidad y seguridad, en una organización privada de atención "
                "médico-quirúrgica de alta especialidad.\n",
        'vision':
            "VISIÓN\nSer la mejor opción de servicios hospitalarios privados en el occidente del país, "
                "en un entorno sustentable y de compromiso social.",
        'valores': 'Valores',
        'compromiso_title': 'Compromiso',
        'compromiso_text':
            "Es la firmeza inquebrantable por cumplir o hacer algo que nos hemos propuesto "
                "o que simplemente debemos hacer. El compromiso va mucho más allá de decir "
                "“está bien, lo haré”, es actuar en consecuencia, es planear el camino a seguir "
                "para llegar a la meta y el trabajo constante hasta lograrlo.",
        'integridad_title': 'Integridad',
        'integridad_text':
            "Implica rectitud, bondad, honradez, intachabilidad; alguien en quien se puede confiar. "
                "«Compórtate en todo momento con la honestidad de un auténtico profesional».",
        'prof_title': 'Profesionalismo',
        'prof_text':
            "Un profesional brinda un servicio o elabora un bien garantizando calidad de excelencia. "
                "Es responsable, honesto, capaz y disciplinado.",
        'confianza_title': 'Confianza',
        'confianza_text':
            "Es la seguridad o esperanza firme que se tiene del compañero. "
                "Permite predecir acciones y comportamientos.",
        'calidez_title': 'Calidez humana',
        'calidez_text':
            "Es una mezcla de caridad, amabilidad, sonrisa y cortesía para el paciente y sus familiares.",
      },

      // ------------------ ENGLISH VERSION ------------------
      'en': {
        'login': 'Sign in',
        'title': 'About Us',
        'quienes': 'Who are we?',
        'quienes_text':
            "We are a certified hospital that provides medical and surgical care, "
                "supported by cutting-edge technology, quality, and human warmth.\n\n"
                "Thanks to our structure and design, we are recognized as a smart hospital "
                "with an innovative hotel-style service concept.\n\n"
                "We are committed to offering quality and safe care to patients, their families, "
                "and our collaborators, in a timely, professional, and technological manner, "
                "within an environment of warmth and teamwork, ensuring satisfaction and exceeding expectations.",
        'mision_vision': 'Mission & Vision',
        'mision':
            "MISSION\nEnsure that Patients, Families, and Physicians are in the “Best Hands”, "
                "with quality and safety processes in a private high-specialty medical-surgical organization.\n",
        'vision':
            "VISION\nTo be the best option for private hospital services in western Mexico, "
                "in a sustainable and socially responsible environment.",
        'valores': 'Values',
        'compromiso_title': 'Commitment',
        'compromiso_text':
            "It is the unwavering determination to fulfill what we have set out to do. "
                "Commitment goes beyond saying “I will do it”; it is acting accordingly.",
        'integridad_title': 'Integrity',
        'integridad_text':
            "It implies honesty, uprightness, and reliability. "
                "A person whose word and actions are consistent.",
        'prof_title': 'Professionalism',
        'prof_text':
            "A professional guarantees excellence, responsibility, honesty, and capability.",
        'confianza_title': 'Trust',
        'confianza_text':
            "It is the firm belief in the reliability and behavior of others.",
        'calidez_title': 'Human warmth',
        'calidez_text':
            "It is kindness, empathy, and compassion toward patients and their families.",
      }
    };

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

            // ---------------- QUIÉNES SOMOS ----------------
            Text(
              t[lang]!['quienes']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              t[lang]!['quienes_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 25),

            // ---------------- MISIÓN Y VISIÓN ----------------
            Text(
              t[lang]!['mision_vision']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              t[lang]!['mision']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 10),

            Text(
              t[lang]!['vision']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 25),

            // ---------------- VALORES ----------------
            Text(
              t[lang]!['valores']!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003DA5),
              ),
            ),

            const SizedBox(height: 20),

            // Imagen de valores (espacio)
            ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
                'assets/images/imagenNosotros.avif',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
            ),
            ),


            const SizedBox(height: 25),

            // ---------------- COMPROMISO ----------------
            Text(
              t[lang]!['compromiso_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t[lang]!['compromiso_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            // ---------------- INTEGRIDAD ----------------
            Text(
              t[lang]!['integridad_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t[lang]!['integridad_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            // ---------------- PROFESIONALISMO ----------------
            Text(
              t[lang]!['prof_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t[lang]!['prof_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            // ---------------- CONFIANZA ----------------
            Text(
              t[lang]!['confianza_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t[lang]!['confianza_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 20),

            // ---------------- CALIDEZ HUMANA ----------------
            Text(
              t[lang]!['calidez_title']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF009639),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t[lang]!['calidez_text']!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
