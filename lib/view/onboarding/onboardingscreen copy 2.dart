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
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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

              // Banner superior (Hospital)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/banner1.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              // Ver ubicación 1
              _locationButton(
                "Ver ubicación Lázaro Cárdenas",
                'https://maps.google.com/?q=Av.+Lázaro+Cárdenas+4149,+Zapopan,+Jalisco',
              ),

              const SizedBox(height: 20),

              // Logo centrado
              Image.asset(
                'assets/icons/logo.jpg',
                height: 100,
              ),

              const SizedBox(height: 20),

              // Banner inferior (Hospital)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/banner2.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 10),

              // Ver ubicación 2
              _locationButton(
                "Ver ubicación Valle Real",
                'https://maps.google.com/?q=Av.+Central+911,+Zapopan,+Jalisco',
              ),

              const SizedBox(height: 30),

              // Botones principales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    // Ya soy usuario
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003DA5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push(LoginScreen.routeName),
                      child: const Text(
                        "Ya soy usuario",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // No soy usuario
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009639),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push(RegisterScreen.routeName),
                      child: const Text(
                        "No soy usuario",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTÓN DE UBICACIÓN (ESTILO BONITO)
  // ---------------------------------------------------------------------------
  Widget _locationButton(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () => openMap(url),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF003DA5), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Color(0xFFB7BF10)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF003DA5),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


