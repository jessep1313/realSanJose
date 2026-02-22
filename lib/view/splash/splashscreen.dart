import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static var routeName = '/';

  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () {
        context.go(OnboardingScreen.routeName);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: bgDecoration(),
        child: Center(
          child: Image.asset(
            'assets/icons/logo.jpg',
            height: 132
          ),
        ),
      ),
    );
  }
}
