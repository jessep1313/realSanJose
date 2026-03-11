import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  final String title;
  final VoidCallback? ontap; // ← AHORA PERMITE NULL
  final Color color;
  final Color textColor;
  final String? image;

  const CustomButton({
    super.key,
    required this.title,
    required this.ontap,
    this.color = const Color(0xFFf56961),
    this.textColor = Colors.white,
    this.image,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ontap == null ? Colors.grey : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: ontap, // ← YA NO MARCA ERROR
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                image!,
                height: 20,
              ),
            if (image != null) const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
