import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:swastha_doctor_flutter/provider/configprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';
import 'package:swastha_doctor_flutter/view/schedule/schedule.dart';
import 'package:swastha_doctor_flutter/view/chat/chatscreen.dart';
import 'package:swastha_doctor_flutter/view/profile/profilescreen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static String routeName = '/dashboardscreen';

  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(configProvider).setController(controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'home': 'Inicio',
        'schedule': 'Agenda',
        'chat': 'Chat',
        'profile': 'Perfil',
      },
      'en': {
        'home': 'Home',
        'schedule': 'Schedule',
        'chat': 'Chat',
        'profile': 'Profile',
      }
    };

    return PersistentTabView(
      context,
      controller: controller,
      screens: [
        HomeTab(), // 👈 Nuevo Home rediseñado
        ScheduleScreen(),
        ChatScreen(),
        Profilescreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.home, size: 20),
          title: textos[lang]!['home']!,
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.calendar_today, size: 20),
          title: textos[lang]!['schedule']!,
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.chat_bubble_outline, size: 20),
          title: textos[lang]!['chat']!,
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_outline, size: 20),
          title: textos[lang]!['profile']!,
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
      ],
      decoration: NavBarDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appAlternateColor,
            const Color(0xFF003DA5), // Pantone azul
          ],
        ),
      ),
      navBarHeight: 65,
    );
  }
}

/// Home rediseñado con cards pequeñas y banner desplazable
class HomeTab extends ConsumerWidget {
  HomeTab({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'hola': 'Hola',
        'rfcCurp': 'RFC / CURP',
        'agenda': 'Agenda',
        'visitas': 'Visitas',
        'recetas': 'Recetas',
        'informativo': 'Informativo',
        'resultados': 'Resultados',
        'ayuda': 'Ayuda',
      },
      'en': {
        'hola': 'Hello',
        'rfcCurp': 'RFC / CURP',
        'agenda': 'Schedule',
        'visitas': 'Visits',
        'recetas': 'Prescriptions',
        'informativo': 'Information',
        'resultados': 'Results',
        'ayuda': 'Help',
      }
    };

    final nombreCliente = "Juan Pérez"; // ejemplo
    final rfcCurpCliente = "CURP: XXXX000000HDFRRR01"; // ejemplo

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none,
                          color: Color(0xFF003DA5)),
                      onPressed: () {
                        // TODO: Navegar a notificaciones
                      },
                    ),
                    Image.asset('assets/icons/logo.jpg', height: 90),
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

              // Hola + RFC/CURP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      "${textos[lang]!['hola']} $nombreCliente",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rfcCurpCliente,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Grid de servicios (cards más pequeñas)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // 👈 más columnas, cards más chicas
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _serviceCard(textos[lang]!['agenda']!, Icons.calendar_today),
                  _serviceCard(textos[lang]!['visitas']!, Icons.people_outline),
                  _serviceCard(
                      textos[lang]!['recetas']!, Icons.medical_services_outlined),
                  _serviceCard(
                      textos[lang]!['informativo']!, Icons.info_outline),
                  _serviceCard(
                      textos[lang]!['resultados']!, Icons.science_outlined),
                  _serviceCard(textos[lang]!['ayuda']!, Icons.help_outline),
                ],
              ),

              const SizedBox(height: 16),

              // Banner desplazable (slider)
              SizedBox(
                height: 150,
                child: PageView(
                  controller: _pageController,
                  children: const [
                    _SliderImage(assetPath: 'assets/images/main_banner.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(String title, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF003DA5), // azul Pantone 293
          width: 2,
        ),
      ),
      elevation: 2,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Color(0xFF009639), size: 28), // verde Pantone 354
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF009639), // verde Pantone 354
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderImage extends StatelessWidget {
  final String assetPath;
  const _SliderImage({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

