import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class CustomHeader extends ConsumerWidget {
  final String title;
  const CustomHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF003DA5)),
            onPressed: () => Navigator.pop(context),
          ),
          Image.asset('assets/icons/logo.jpg', height: 70),
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
    );
  }
}
