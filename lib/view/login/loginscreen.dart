import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';
import 'package:real_san_jose/view/forgotpassword/forgotpasswordscreen.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/view/register/register.dart';
import 'package:real_san_jose/provider/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Reutilizamos el provider de idioma definido en OnboardingScreen
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static var routeName = "/loginscreen";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;

  void showAlert(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> doLogin() async {
    final user = userController.text.trim();
    final pass = passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      showAlert("Usuario y contraseña son obligatorios");
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ref.read(
        loginProvider({
          "identificator": user,
          "password": pass,
        }).future,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token_usuario", result["token"]);
      await prefs.setString("fullname", result["Fullname"]);
      await prefs.setString("curp", result["Curp"]);

      context.push(DashboardScreen.routeName);
    } catch (e) {
      showAlert("Datos incorrectos");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final texts = {
      'es': {
        'title': 'Inicia sesión para continuar',
        'user': 'RFC / CURP / Correo',
        'password': 'Contraseña',
        'forgot': '¿Olvidaste tu contraseña?',
        'login': 'Login',
        'noAccount': '¿No tienes cuenta?',
        'signup': 'Registrarse',
      },
      'en': {
        'title': 'Login to get started',
        'user': 'RFC / CURP / Email',
        'password': 'Password',
        'forgot': 'Forgot password?',
        'login': 'Login',
        'noAccount': 'Don\'t have an account?',
        'signup': 'Sign Up',
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
              context.push(OnboardingScreen.routeName);
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
                          height: 90,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text(
                            texts[lang]!['title']!,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
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
                        color: Colors.grey.withOpacity(0.2),
                        hintText: texts[lang]!['user']!,
                        controller: userController,
                        textInputType: TextInputType.text,
                        leadingIconData: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        texts[lang]!['password']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        color: Colors.grey.withOpacity(0.2),
                        hintText: texts[lang]!['password']!,
                        controller: passController,
                        textInputType: TextInputType.visiblePassword,
                        isPassword: true,
                        leadingIconData: const Icon(Icons.lock),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              context.push(ForgotPasswordScreen.routeName);
                            },
                            child: Text(
                              texts[lang]!['forgot']!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        title:
                            isLoading ? "Cargando..." : texts[lang]!['login']!,
                        ontap: isLoading ? null : () => doLogin(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    texts[lang]!['noAccount']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(RegisterScreen.routeName);
                    },
                    child: Text(
                      ' ${texts[lang]!['signup']!}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
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
