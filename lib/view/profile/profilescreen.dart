import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/provider/configprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/editprofile/editprofilescreen.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';







class Profilescreen extends ConsumerWidget {
  static var routeName = "/profilescreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'perfil': 'Perfil',
        'facturas': 'Facturas',
        'documentos': 'Documentos',
      },
      'en': {
        'perfil': 'Profile',
        'facturas': 'Invoices',
        'documentos': 'Documents',
      }
    };

    // Datos de ejemplo, vendrán de tu modelo de usuario
    final nombreCliente = "Juan Pérez";
    final correoCliente = "juanperez@gmail.com";
    final telefonoCliente = "+52 3312345678";
    final rfcCliente = "PEPJ8001019Q8";
    final curpCliente = "PEPJ800101HDFRRN01";

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Color(0xFF003DA5), size: 28),
            onPressed: () {
              context.push(NotificationScreen.routeName);
            },
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
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.appBackgroundColor,
                  borderRadius: borderRadius(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Datos del cliente
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF003DA5), // azul Pantone
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  foregroundImage: AssetImage(
                                      'assets/images/specialist.jpg'),
                                  radius: 35,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nombreCliente,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF009639), // verde Pantone
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text("Correo: $correoCliente",
                                          style: const TextStyle(fontSize: 12)),
                                      Text("Teléfono: $telefonoCliente",
                                          style: const TextStyle(fontSize: 12)),
                                      Text("RFC: $rfcCliente",
                                          style: const TextStyle(fontSize: 12)),
                                      Text("CURP: $curpCliente",
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context.push(EditProfileScreen.routeName);
                                  },
                                  child: Card(
                                    color: const Color(0xFF003DA5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(Icons.edit,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Botones Facturas y Documentos
                          Row(
                            children: [
                              Expanded(
                                child: _customActionButton(
                                  title: textos[lang]!['facturas']!,
                                  icon: Icons.receipt_long,
                                  onTap: () {
                                    // TODO: Navegar a pantalla de facturas
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _customActionButton(
                                  title: textos[lang]!['documentos']!,
                                  icon: Icons.folder_open,
                                  onTap: () {
                                    // TODO: Navegar a pantalla de documentos
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Banner / imágenes
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://cninfotech.com/portfolio/?action=mobile'));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/images/profilebaner1.png'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://cninfotech.com/portfolio/?action=mobile'));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/images/profilebaner2.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _customActionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF003DA5), // azul Pantone
            width: 2,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF009639), size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF009639), // verde Pantone
                  fontSize: 14,
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


