import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/view/schedule/schedule.dart';
import 'package:real_san_jose/view/chat/chatscreen.dart';
import 'package:real_san_jose/view/profile/profilescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Nuevas pantallas
import 'package:real_san_jose/view/agendar/agendar_screen.dart';
import 'package:real_san_jose/view/agendar/agendar_cirugia_screen.dart';
import 'package:real_san_jose/view/lab/lab_results_screen.dart';
import 'package:real_san_jose/view/rayosx/rayosx_screen.dart';
import 'package:real_san_jose/view/notas/notas_screen.dart';
import 'package:real_san_jose/view/expediente/expediente_screen.dart';
import 'package:real_san_jose/view/ayuda/ayuda_screen.dart';
import 'package:real_san_jose/view/cirugias/cirugias_programadas_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static String routeName = '/dashboardscreen';

  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  late PersistentTabController controller;

  String fullname = "";
  String curp = "";

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(configProvider).setController(controller);
      loadUserData();
    });
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullname = prefs.getString("fullname") ?? "";
      curp = prefs.getString("curp") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'home': 'Inicio',
        'schedule': 'Citas',
        'chat': 'Chat',
        'profile': 'Perfil',
        'logout': 'Cerrar sesión',
      },
      'en': {
        'home': 'Home',
        'schedule': 'Appointments',
        'chat': 'Chat',
        'profile': 'Profile',
        'logout': 'Logout',
      }
    };

    return PersistentTabView(
      context,
      controller: controller,
      screens: [
        HomeTab(fullname: fullname, curp: curp),
        ScheduleScreen(),
        Profilescreen(),
        Container(),
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
          icon: const Icon(Icons.person_outline, size: 20),
          title: textos[lang]!['profile']!,
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),

        // 🔥 CERRAR SESIÓN
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.logout, size: 20),
          title: "",
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
          onPressed: (navContext) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(textos[lang]!['logout']!),
                content: Text(lang == 'es'
                    ? "¿Deseas cerrar sesión?"
                    : "Do you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(lang == 'es' ? "No" : "No"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => OnboardingScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(lang == 'es' ? "Sí" : "Yes"),
                  ),
                ],
              ),
            );
          },
        ),
      ],
      decoration: NavBarDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appAlternateColorw,
            const Color(0xFF8B8E00),
          ],
        ),
      ),
      navBarHeight: 65,
    );
  }
}

/// HOME TAB
class HomeTab extends ConsumerWidget {
  final String fullname;
  final String curp;

  const HomeTab({
    super.key,
    required this.fullname,
    required this.curp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'hola': 'Hola',
        'agendar': 'Agendar cita',
        'misCitas': 'Mis citas',
        'lab': 'Resultados laboratorio',
        'rayosx': 'Rayos X',
        'notas': 'Notas médicas',
        'historial': 'Historial',
        'ayuda': 'Ayuda',
      },
      'en': {
        'hola': 'Hello',
        'agendar': 'Book appointment',
        'misCitas': 'My appointments',
        'lab': 'Lab results',
        'rayosx': 'X-Rays',
        'notas': 'Medical notes',
        'historial': 'History',
        'ayuda': 'Help',
      }
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ⭐ HEADER EXACTO COMO PROFILESCREEN
            AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.notifications_none,
                    color: Color(0xFF003DA5), size: 28),
                onPressed: () {},
              ),
              title: Center(
                child: Image.asset('assets/icons/logo.jpg', height: 90),
              ),
              actions: [
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

            const SizedBox(height: 10), // ⭐ MÁS ESPACIO DESPUÉS DEL HEADER

            // ⭐ SALUDO CENTRADO + NOMBRE DEBAJO
            Column(
              children: [
                Text(
                  textos[lang]!['hola']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0166B8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  fullname,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  "CURP: $curp",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 25), // ⭐ MÁS ESPACIO ANTES DEL GRID

            // ⭐ GRID DE SERVICIOS
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _serviceCard(
                    lang == 'es' ? 'Agendar cita' : 'Book appointment',
                    Icons.add_circle_outline,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AgendarScreen()),
                      );
                    },
                  ),
                  _serviceCard(
                    lang == 'es' ? 'Mis citas' : 'My appointments',
                    Icons.event_note,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ScheduleScreen()),
                      );
                    },
                  ),
                  _serviceCard(
                    lang == 'es' ? 'Programar cirugía' : 'Schedule surgery',
                    Icons.medical_services,
                    () {
                      final sucursales = [
                        {"id": 1, "nombre": "Sucursal Centro"},
                        {"id": 2, "nombre": "Sucursal Norte"},
                      ];
                      final aseguradoras = ["AXA", "GNP", "Mapfre"];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AgendarCirugiaScreen(
                            sucursales: sucursales,
                            aseguradoras: aseguradoras,
                          ),
                        ),
                      );
                    },
                  ),

                  _serviceCard(
                    lang == 'es'
                        ? 'Cirugías programadas'
                        : 'Scheduled surgeries',
                    Icons.medical_services,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CirugiasProgramadasScreen()),
                      );
                    },
                  ),
                  _serviceCard(
                    lang == 'es' ? 'Resultados de laboratorio' : 'Lab results',
                    Icons.biotech,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LabResultsScreen()),
                      );
                    },
                  ),
                  _serviceCard(
                    lang == 'es' ? 'Rayos X' : 'X-Rays',
                    Icons.image_search,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RayosXScreen()),
                      );
                    },
                  ),
                  // ⭐ NUEVA OPCIÓN: NOTAS MÉDICAS
                  _serviceCard(
                    lang == 'es' ? 'Notas médicas' : 'Medical notes',
                    Icons.note_alt,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotasScreen()),
                      );
                    },
                  ),
                  _serviceCard(
                    lang == 'es' ? 'Histórico' : 'History',
                    Icons.folder_shared,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExpedienteScreen()),
                      );
                    },
                  ),
                  // ⭐ NUEVO: Agendar cita médica
                  _serviceCard(
                    lang == 'es'
                        ? 'Agendar cita médica'
                        : 'Book medical appointment',
                    Icons.local_hospital,
                    () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                              lang == 'es' ? 'Próximamente' : 'Coming soon'),
                          content: Text(lang == 'es'
                              ? 'Esta función estará disponible próximamente.'
                              : 'This feature will be available soon.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              child: Text(lang == 'es' ? 'Cerrar' : 'Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // ⭐ NUEVO: Mis citas médicas
                  _serviceCard(
                    lang == 'es'
                        ? 'Mis citas médicas'
                        : 'My medical appointments',
                    Icons.assignment,
                    () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                              lang == 'es' ? 'Próximamente' : 'Coming soon'),
                          content: Text(lang == 'es'
                              ? 'Esta función estará disponible próximamente.'
                              : 'This feature will be available soon.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(),
                              child: Text(lang == 'es' ? 'Cerrar' : 'Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF8B8E00),
            width: 2,
          ),
        ),
        elevation: 2,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF0166B8), size: 28),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0166B8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
