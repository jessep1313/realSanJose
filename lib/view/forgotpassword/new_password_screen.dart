import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  static var routeName = "/newpassword";
  final String email;
  final String code;

  const NewPasswordScreen({super.key, required this.email, required this.code});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final texts = {
      'es': {
        'title': 'Nueva contraseña',
        'subtitle': 'Ingresa tu nueva contraseña',
        'newPassword': 'Nueva contraseña',
        'confirmPassword': 'Confirmar contraseña',
        'submit': 'Cambiar contraseña',
        'errorMatch': 'Las contraseñas no coinciden',
        'errorLength': 'La contraseña debe tener al menos 6 caracteres',
        'success': 'Contraseña actualizada correctamente',
      },
      'en': {
        'title': 'New password',
        'subtitle': 'Enter your new password',
        'newPassword': 'New password',
        'confirmPassword': 'Confirm password',
        'submit': 'Change password',
        'errorMatch': 'Passwords do not match',
        'errorLength': 'Password must be at least 6 characters',
        'success': 'Password updated successfully',
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
                        texts[lang]!['subtitle']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Campo: Nueva contraseña
                      TextField(
                        controller: newPasswordController,
                        obscureText: obscureNew,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          hintText: texts[lang]!['newPassword']!,
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureNew
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() => obscureNew = !obscureNew);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Campo: Confirmar contraseña
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirm,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          hintText: texts[lang]!['confirmPassword']!,
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() => obscureConfirm = !obscureConfirm);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              title: texts[lang]!['submit']!,
                              ontap: () async {
                                final newPass =
                                    newPasswordController.text.trim();
                                final confirmPass =
                                    confirmPasswordController.text.trim();
                                if (newPass.isEmpty || confirmPass.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Completa todos los campos')),
                                  );
                                  return;
                                }
                                if (newPass.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(texts[lang]!['errorLength']!)),
                                  );
                                  return;
                                }
                                if (newPass != confirmPass) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(texts[lang]!['errorMatch']!)),
                                  );
                                  return;
                                }

                                setState(() => isLoading = true);
                                try {
                                  final service = AuthService();
                                  await service.UserPasswordUpdate(
                                    widget.email,
                                    widget.code,
                                    newPass,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(texts[lang]!['success']!)),
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()),
                                    (route) => false,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
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
          ],
        ),
      ),
    );
  }
}
