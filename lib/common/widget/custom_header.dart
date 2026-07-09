import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/view/onboarding/onboardingscreen.dart';

class CustomHeader extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onBack; // Si se pasa, muestra flecha atrás
  final String? title; // Título opcional (se muestra junto al logo)
  final List<Widget>? actions; // Acciones personalizadas (dropdown por defecto)
  final double? height; // Altura personalizada (opcional)

  const CustomHeader({
    super.key,
    this.onBack,
    this.title,
    this.actions,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      toolbarHeight: height ?? kToolbarHeight,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF003DA5)),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF003DA5)),
              onPressed: () => Navigator.pop(context),
            ),
      title: title != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/logo.jpg', height: 90),
                const SizedBox(width: 10)
              ],
            )
          : Center(
              child: Image.asset('assets/icons/logo.jpg', height: 90),
            ),
      centerTitle: true,
      actions: actions ??
          [
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
