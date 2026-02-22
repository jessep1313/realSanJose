import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORTA LAS SECCIONES
import 'package:real_san_jose/view/nosotros/nosotros_screen.dart';
import 'package:real_san_jose/view/servicios/servicios_screen.dart';
import 'package:real_san_jose/view/especialidades/especialidades_screen.dart';
import 'package:real_san_jose/view/maternidad/maternidad_screen.dart';
import 'package:real_san_jose/view/directorio/directorio_screen.dart';

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
  bool _isMenuOpen = false;

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

  final texts = {
    'es': {
      'loginHeader': 'Iniciar sesión',
      'nosotros': 'Nosotros',
      'servicios': 'Servicios médicos',
      'especialidades': 'Especialidades',
      'maternidad': 'Maternidad',
      'directorio': 'Directorio médico',
      'signup': 'No soy usuario',
      'viewLocations': 'Ver ubicaciones',
      'terms': 'Términos y condiciones',
      'locationModal': 'Selecciona una ubicación',
      'hospital1': 'Hospital Lázaro Cárdenas',
      'hospital2': 'Hospital Valle Real',
      'termsTitle': 'Términos y Condiciones',
      'termsText': 'Este es un texto de ejemplo para los términos y condiciones.',
    },
    'en': {
      'loginHeader': 'Sign in',
      'nosotros': 'About Us',
      'servicios': 'Medical Services',
      'especialidades': 'Specialties',
      'maternidad': 'Maternity',
      'directorio': 'Medical Directory',
      'signup': 'I am not a user',
      'viewLocations': 'View locations',
      'terms': 'Terms and Conditions',
      'locationModal': 'Select a location',
      'hospital1': 'Lázaro Cárdenas Hospital',
      'hospital2': 'Valle Real Hospital',
      'termsTitle': 'Terms and Conditions',
      'termsText': 'This is a sample text for the terms and conditions section.',
    }
  };

  // ---------------------- MODAL TÉRMINOS ----------------------
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

  // ---------------------- MODAL UBICACIONES ----------------------
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
                  openMap("https://maps.google.com/?q=Av.+Lázaro+Cárdenas+4149,+Zapopan,+Jalisco");
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_hospital, color: Color(0xFF003DA5)),
                title: Text(texts[lang]!['hospital2']!),
                onTap: () {
                  Navigator.pop(context);
                  openMap("https://maps.google.com/?q=Av.+Central+911,+Zapopan,+Jalisco");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------- ITEM DEL MENÚ ----------------------
  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------- MENÚ AZUL ----------------------
  Widget _menuGrid(String lang) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF003DA5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2,
        children: [
          _menuItem(Icons.info_outline, texts[lang]!['nosotros']!, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NosotrosScreen()));
          }),
          _menuItem(Icons.local_hospital, texts[lang]!['servicios']!, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ServiciosScreen()));
          }),
          _menuItem(Icons.medical_services_outlined,
              texts[lang]!['especialidades']!, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EspecialidadesScreen()));
          }),
          _menuItem(Icons.child_friendly, texts[lang]!['maternidad']!, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MaternidadScreen()));
          }),
          _menuItem(Icons.people_alt_outlined, texts[lang]!['directorio']!, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const DirectorioScreen()));
          }),
        ],
      ),
    );
  }

  // ---------------------- UI PRINCIPAL ----------------------
  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------------------- HEADER ----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isMenuOpen ? Icons.close : Icons.menu,
                        size: 28,
                        color: const Color(0xFF003DA5),
                      ),
                      onPressed: () {
                        setState(() {
                          _isMenuOpen = !_isMenuOpen;
                        });
                      },
                    ),

                    // INICIAR SESIÓN (con icono)
                    InkWell(
                      onTap: () => context.push(LoginScreen.routeName),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 22, color: Color(0xFF003DA5)),
                          const SizedBox(width: 6),
                          Text(
                            texts[lang]!['loginHeader']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003DA5),
                            ),
                          ),
                        ],
                      ),
                    ),

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
                          saveLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // ---------------------- MENÚ DESPLEGABLE ----------------------
              if (_isMenuOpen) _menuGrid(lang),

              // ---------------------- BANNER SUPERIOR ----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/banner1.avif',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ---------------------- LOGO ----------------------
              Image.asset(
                'assets/icons/logo.jpg',
                height: 100,
              ),

              const SizedBox(height: 20),

              // ---------------------- BANNER INFERIOR ----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/banner2.avif',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------------- BOTONES PRINCIPALES ----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
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

              // ---------------------- TÉRMINOS ----------------------
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
