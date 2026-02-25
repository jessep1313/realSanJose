import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/editprofile/editprofilescreen.dart';
import 'package:real_san_jose/view/notification/notificationscreen.dart';
import 'package:url_launcher/url_launcher.dart';

// ⭐ IMPORT CORRECTO DEL PROVIDER DE IDIOMA
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class Profilescreen extends ConsumerWidget {
  static var routeName = "/profilescreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'perfil': 'Perfil',
        'correo': 'Correo',
        'telefono': 'Teléfono',
        'rfc': 'RFC',
        'curp': 'CURP',
        'editar': 'Editar perfil',
      },
      'en': {
        'perfil': 'Profile',
        'correo': 'Email',
        'telefono': 'Phone',
        'rfc': 'Tax ID',
        'curp': 'National ID',
        'editar': 'Edit profile',
      }
    };

    // Datos de ejemplo (luego se reemplazan con tu modelo real)
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
                          // ⭐ DATOS DEL PERFIL
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF003DA5),
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
                                          color: Color(0xFF009639),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${textos[lang]!['correo']}: $correoCliente",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${textos[lang]!['telefono']}: $telefonoCliente",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${textos[lang]!['rfc']}: $rfcCliente",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "${textos[lang]!['curp']}: $curpCliente",
                                        style: const TextStyle(fontSize: 12),
                                      ),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            textos[lang]!['editar']!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ⭐ BANNERS
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://cninfotech.com/portfolio/?action=mobile'));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  'assets/images/profilebaner1.png'),
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
                              child: Image.asset(
                                  'assets/images/profilebaner2.png'),
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
}
