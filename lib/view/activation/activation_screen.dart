import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/api/auth_service.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';
import 'package:real_san_jose/view/login/loginscreen.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';

class ActivationScreen extends ConsumerStatefulWidget {
  static const routeName = "/activationscreen";
  final String email;

  const ActivationScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActivationScreenState();
}

class _ActivationScreenState extends ConsumerState<ActivationScreen> {
  final codeCtrl = TextEditingController();
  bool canResend = false;
  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _sendCode(); // enviar automáticamente al entrar
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    secondsRemaining = 60;
    canResend = false;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        setState(() => canResend = true);
        t.cancel();
      }
    });
  }

  Future<void> _sendCode() async {
    try {
      final service = AuthService();
      await service.sendActivationCode(widget.email);
      final lang = ref.read(languageProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang == 'es'
              ? "Código enviado a ${widget.email}"
              : "Code sent to ${widget.email}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error enviando código: $e")),
      );
    }
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    final textos = {
      'es': {
        'title': 'Activación de Usuario',
        'email': 'Email',
        'codigo': 'Código de activación',
        'leyenda':
            'Te llegó a tu correo el código de activación, favor de ingresar',
        'reenviar': 'Reenviar código',
        'enviar': 'Enviar código',
      },
      'en': {
        'title': 'User Activation',
        'email': 'Email',
        'codigo': 'Activation code',
        'leyenda':
            'The activation code was sent to your email, please enter it',
        'reenviar': 'Resend code',
        'enviar': 'Submit code',
      }
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.home,
                      color: Color(0xFF003DA5), size: 28),
                  onPressed: () => context.go(OnboardingScreen.routeName),
                ),
                Center(
                  child: Image.asset('assets/icons/logo.jpg', height: 90),
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
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              textos[lang]!['title']!,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003DA5)),
            ),
            const SizedBox(height: 20),

            Text("${textos[lang]!['email']!}: ${widget.email}"),
            const SizedBox(height: 20),

            // Input estilo login
            CustomTextField(
              color: Colors.grey.withOpacity(0.2),
              hintText: textos[lang]!['codigo']!,
              controller: codeCtrl,
              textInputType: TextInputType.number,
              leadingIconData: const Icon(Icons.confirmation_number),
            ),
            const SizedBox(height: 10),

            Text(
              textos[lang]!['leyenda']!,
              style: const TextStyle(color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Botón estilo login
            CustomButton(
              title: textos[lang]!['enviar']!,
              ontap: () async {
                final service = AuthService();
                try {
                  final resp = await service.activateUser(
                      widget.email, codeCtrl.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(resp['message'] ?? 'Activación exitosa')),
                  );

                  Future.delayed(const Duration(milliseconds: 800), () {
                    context.go(LoginScreen.routeName);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error activando usuario: $e")),
                  );
                }
              },
              color: const Color(0xFF003DA5),
              textColor: Colors.white,
            ),

            const SizedBox(height: 20),

            // Texto reenviar con contador
            GestureDetector(
              onTap: canResend
                  ? () {
                      _sendCode();
                      _startTimer();
                    }
                  : null,
              child: Text(
                "${textos[lang]!['reenviar']} ${canResend ? '' : '(${secondsRemaining}s)'}",
                style: TextStyle(
                  color: canResend ? const Color(0xFF003DA5) : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
