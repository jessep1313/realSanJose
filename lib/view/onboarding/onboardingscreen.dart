import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastha_doctor_flutter/view/login/loginscreen.dart';
import 'package:swastha_doctor_flutter/view/register/register.dart';

/// Provider para manejar el idioma seleccionado
final languageProvider = StateProvider<String>((ref) => 'es');

class OnboardingScreen extends ConsumerStatefulWidget {
  static var routeName = "/onboardingscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      OnBoardingScreenState();
}

class OnBoardingScreenState extends ConsumerState<OnboardingScreen> {
  Future<void> openMap(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el mapa: $url';
    }
  }

  /// Guardar idioma en SharedPreferences
  Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
  }

  /// Cargar idioma al iniciar
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('app_language') ?? 'es';
    ref.read(languageProvider.notifier).state = lang;
  }

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    // Textos en ambos idiomas
    final texts = {
      'es': {
        'welcome': 'Bienvenido',
        'description':
            'Hospital Real San José es una institución médica de alta especialidad en Guadalajara, con dos sedes: Valle Real y Lázaro Cárdenas. Brindamos atención integral con tecnología de vanguardia y calidez humana.',
        'location1': 'Ver ubicación Lázaro Cárdenas',
        'location2': 'Ver ubicación Valle Real',
        'login': 'Login',
        'signup': 'Registrarse',
        'terms': 'Al continuar, aceptas los Términos y Condiciones',
      },
      'en': {
        'welcome': 'Welcome',
        'description':
            'Hospital Real San José is a high-specialty medical institution in Guadalajara, with two branches: Valle Real and Lázaro Cárdenas. We provide comprehensive care with cutting-edge technology and human warmth.',
        'location1': 'View location Lázaro Cárdenas',
        'location2': 'View location Valle Real',
        'login': 'Login',
        'signup': 'Sign Up',
        'terms': 'By continuing, you agree to the Terms and Conditions',
      }
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Selector de idioma
              Align(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  value: lang,
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('ES 🇲🇽')),
                    DropdownMenuItem(value: 'en', child: Text('EN 🇺🇸')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).state = value;
                      saveLanguage(value);
                    }
                  },
                ),
              ),

              // Logo institucional
              Image.asset('assets/icons/logo.jpg', height: 80),

              const SizedBox(height: 20),

              // Título Bienvenido con gradiente
              Text(
                texts[lang]!['welcome']!,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        Color(0xFF003DA5), // Pantone 293
                        Color(0xFFB7BF10), // Pantone 582
                      ],
                    ).createShader(
                      Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                    ),
                ),
              ),

              const SizedBox(height: 20),

              // Texto institucional
              Text(
                texts[lang]!['description']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 30),

              // Banner 1
              Image.asset('assets/images/banner2.png'),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.location_on, color: Color(0xFFB7BF10)),
                label: Text(
                  texts[lang]!['location1']!,
                  style: const TextStyle(color: Color(0xFF003DA5)),
                ),
                onPressed: () {
                  openMap(
                      'https://maps.google.com/?q=Av.+Lázaro+Cárdenas+4149,+Zapopan,+Jalisco');
                },
              ),

              const SizedBox(height: 30),

              // Banner 2
              Image.asset('assets/images/banner1.png'),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.location_on, color: Color(0xFFB7BF10)),
                label: Text(
                  texts[lang]!['location2']!,
                  style: const TextStyle(color: Color(0xFF003DA5)),
                ),
                onPressed: () {
                  openMap(
                      'https://maps.google.com/?q=Av.+Central+911,+Zapopan,+Jalisco');
                },
              ),

              const SizedBox(height: 30),

              // Botones Login / Sign Up
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0xFF003DA5), width: 2),
                          ),
                        ),
                        onPressed: () {
                          context.push(LoginScreen.routeName);
                        },
                        child: Text(
                          texts[lang]!['login']!,
                          style: const TextStyle(
                            color: Color(0xFFB7BF10),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: Color(0xFF003DA5), width: 2),
                          ),
                        ),
                        onPressed: () {
                          context.push(RegisterScreen.routeName);
                        },
                        child: Text(
                          texts[lang]!['signup']!,
                          style: const TextStyle(
                            color: Color(0xFFB7BF10),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              Text(
                texts[lang]!['terms']!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


