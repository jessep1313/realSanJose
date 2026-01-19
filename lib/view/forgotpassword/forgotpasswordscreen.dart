import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/common/widget/customtextfield.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

// Reutilizamos el provider de idioma definido en OnboardingScreen
import 'package:swastha_doctor_flutter/view/onboarding/onboardingscreen.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  static var routeName = "/forgotscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    final texts = {
      'es': {
        'title': 'Recuperar contraseña',
        'user': 'RFC / CURP / Correo',
        'hint': 'Ingresa RFC, CURP o correo',
        'submit': 'Enviar',
        'message': 'Ingresa tus datos para recuperar la contraseña.',
      },
      'en': {
        'title': 'Forgot Password',
        'user': 'RFC / CURP / Email',
        'hint': 'Enter RFC, CURP or email',
        'submit': 'Submit',
        'message': 'Enter your data to reset password.',
      }
    };

    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF003DA5)),
            onPressed: () {
              context.pop(); // Regresa a la pantalla anterior
            },
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
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/logo.jpg',
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            texts[lang]!['title']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        texts[lang]!['user']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        color: Colors.grey.withOpacity(0.3),
                        hintText: texts[lang]!['hint']!,
                        controller: TextEditingController(),
                        textInputType: TextInputType.text,
                        leadingIconData: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        title: texts[lang]!['submit']!,
                        ontap: () {
                          // Aquí iría la lógica de recuperación
                        },
                        color: const Color(0xFF003DA5), // Pantone azul
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    texts[lang]!['message']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

