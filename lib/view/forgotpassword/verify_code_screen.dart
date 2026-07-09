// lib/view/forgotpassword/verify_code_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class VerifyCodeScreen extends ConsumerStatefulWidget {
  static const routeName = 'verifycode';
  final String email;

  const VerifyCodeScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyCodeScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscureNew = true;
  bool obscureRepeat = true;

  @override
  void dispose() {
    codeController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resendCode() async {
    setState(() => isLoading = true);
    try {
      final service = AuthService();
      await service.sendActivationCode(widget.email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código reenviado')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reenviar: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _submit() async {
    final code = codeController.text.trim();
    final newPass = newPasswordController.text.trim();
    final repeatPass = repeatPasswordController.text.trim();

    if (code.isEmpty || newPass.isEmpty || repeatPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (newPass != repeatPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final service = AuthService();
      final Map<String, dynamic> result =
          await service.UserPasswordUpdate(widget.email, code, newPass);

      if (result['Ok'] == true || result['ok'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['Mensaje']?.toString() ??
                'Contraseña actualizada correctamente'),
          ),
        );

        if (!mounted) return;
        // Ajusta la ruta de destino según tu app (ej. '/login' o routeName)
        context.go('/login');
      } else {
        final msg = result['Mensaje'] ??
            result['message'] ??
            jsonEncode(result); // fallback
        throw Exception(msg);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final texts = {
      'es': {
        'title': 'Verificación',
        'subtitle':
            'Ingresa el código enviado a tu correo y crea tu nueva contraseña',
        'hintCode': 'Ingresa el código',
        'newPass': 'Nueva contraseña',
        'repeatPass': 'Repite contraseña',
        'submit': 'Verificar y actualizar',
        'resend': 'Reenviar código',
      },
      'en': {
        'title': 'Verification',
        'subtitle':
            'Enter the code sent to your email and create a new password',
        'hintCode': 'Enter the code',
        'newPass': 'New password',
        'repeatPass': 'Repeat password',
        'submit': 'Verify and update',
        'resend': 'Resend code',
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
            onPressed: () => context.pop(),
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
                if (value != null)
                  ref.read(languageProvider.notifier).state = value;
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 12),

                        // Código (TextFormField estándar)
                        TextFormField(
                          controller: codeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                            hintText: texts[lang]!['hintCode']!,
                            prefixIcon: const Icon(Icons.vpn_key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Nueva contraseña (TextFormField estándar)
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: obscureNew,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                            hintText: texts[lang]!['newPass']!,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureNew
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () =>
                                  setState(() => obscureNew = !obscureNew),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Repetir contraseña (TextFormField estándar)
                        TextFormField(
                          controller: repeatPasswordController,
                          obscureText: obscureRepeat,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.3),
                            hintText: texts[lang]!['repeatPass']!,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureRepeat
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(
                                  () => obscureRepeat = !obscureRepeat),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Botón verificar y actualizar
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                title: texts[lang]!['submit']!,
                                ontap: _submit,
                                color: const Color(0xFF003DA5),
                                textColor: Colors.white,
                              ),

                        const SizedBox(height: 10),

                        // Reenviar código
                        Center(
                          child: TextButton(
                            onPressed: isLoading ? null : _resendCode,
                            child: Text(texts[lang]!['resend']!),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
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
