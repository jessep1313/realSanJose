import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/view/register/register.dart';

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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', lang);
  }

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

  // ---------------------------------------------------------------------------
  // TEXTOS EN DOS IDIOMAS
  // ---------------------------------------------------------------------------
  final texts = {
    'es': {
      'locationModal': 'Selecciona una ubicación',
      'hospital1': 'Hospital Lázaro Cárdenas',
      'hospital2': 'Hospital Valle Real',
      'login': 'Ya soy usuario',
      'signup': 'No soy usuario',
      'viewLocations': 'Ver ubicaciones',
      'terms': 'Términos y condiciones',
      'termsTitle': 'Términos y Condiciones',
      'termsText':
          'Este es un texto de ejemplo para los términos y condiciones.',
    },
    'en': {
      'locationModal': 'Select a location',
      'hospital1': 'Lázaro Cárdenas Hospital',
      'hospital2': 'Valle Real Hospital',
      'login': 'I am a user',
      'signup': 'I am not a user',
      'viewLocations': 'View locations',
      'terms': 'Terms and Conditions',
      'termsTitle': 'Terms and Conditions',
      'termsText':
          'This is a sample text for the terms and conditions section.',
    }
  };

  // ---------------------------------------------------------------------------
  // MODAL DE UBICACIONES
  // ---------------------------------------------------------------------------
  void showLocationModal(String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                texts[lang]!['locationModal']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003DA5),
                ),
              ),
              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.local_hospital, color: Color(0xFF009639)),
                title: Text(texts[lang]!['hospital1']!),
                onTap: () {
                  Navigator.pop(context);
                  openMap(
                      "https://maps.google.com/?q=Av.+Lázaro+Cárdenas+4149,+Zapopan,+Jalisco");
                },
              ),

              ListTile(
                leading: const Icon(Icons.local_hospital, color: Color(0xFF003DA5)),
                title: Text(texts[lang]!['hospital2']!),
                onTap: () {
                  Navigator.pop(context);
                  openMap(
                      "https://maps.google.com/?q=Av.+Central+911,+Zapopan,+Jalisco");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // MODAL DE TÉRMINOS Y CONDICIONES
  // ---------------------------------------------------------------------------
  void showTermsModal(String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  texts[lang]!['termsTitle']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003DA5),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  texts[lang]!['termsText']!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // UI PRINCIPAL
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Selector de idioma
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, top: 10),
                  child: DropdownButton<String>(
                    value: lang,
                    underline: const SizedBox(),
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
              ),

              const SizedBox(height: 10),

              // Banner superior
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/banner1.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              // Logo
              Image.asset(
                'assets/icons/logo.jpg',
                height: 100,
              ),

              const SizedBox(height: 20),

              // Banner inferior
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/banner2.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 30),

              // Botones principales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003DA5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push(LoginScreen.routeName),
                      child: Text(
                        texts[lang]!['login']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009639),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push(RegisterScreen.routeName),
                      child: Text(
                        texts[lang]!['signup']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ÚNICO botón Ver ubicaciones
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Color(0xFF003DA5), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => showLocationModal(lang),
                      child: Text(
                        texts[lang]!['viewLocations']!,
                        style: const TextStyle(color: Color(0xFF003DA5)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Términos y condiciones
              GestureDetector(
                onTap: () => showTermsModal(lang),
                child: Text(
                  texts[lang]!['terms']!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
