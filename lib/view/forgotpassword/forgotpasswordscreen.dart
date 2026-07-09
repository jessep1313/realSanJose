import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/forgotpassword/verify_code_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static var routeName = "/forgotscreen";

  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final texts = {
      'es': {
        'title': 'Recuperar contraseña',
        'user': 'Correo electrónico',
        'hint': 'Ingresa tu correo',
        'submit': 'Enviar código',
        'message': 'Te enviaremos un código de verificación.',
      },
      'en': {
        'title': 'Forgot Password',
        'user': 'Email',
        'hint': 'Enter your email',
        'submit': 'Send code',
        'message': 'We will send you a verification code.',
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
              context.pop();
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
                        controller: emailController,
                        textInputType: TextInputType.emailAddress,
                        leadingIconData: const Icon(Icons.email),
                      ),
                      const SizedBox(height: 10),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              title: texts[lang]!['submit']!,
                              ontap: () async {
                                final email = emailController.text.trim();
                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Ingresa tu correo'),
                                    ),
                                  );
                                  return;
                                }
                                setState(() => isLoading = true);
                                try {
                                  final service = AuthService();
                                  final result =
                                      await service.sendActivationCode(email);
                                  // Si la respuesta es exitosa (aunque sea texto plano)
                                  if (result['success'] == true ||
                                      result['message'] != null) {
                                    // Navegar a la pantalla de verificación
                                    context.pushNamed(
                                      VerifyCodeScreen.routeName,
                                      extra: {'email': email},
                                    );
                                  } else {
                                    throw Exception(
                                        'No se pudo enviar el código');
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Error al enviar código: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  if (mounted)
                                    setState(() => isLoading = false);
                                }
                              },
                              color: const Color(0xFF003DA5),
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
              child: Text(
                texts[lang]!['message']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
