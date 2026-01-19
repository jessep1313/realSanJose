import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  final String title;
  final VoidCallback ontap;
  final Color color;
  final Color textColor;
  final String? image;

  const CustomButton(
      {super.key,
      required this.title,
      required this.ontap,
      this.color = const Color(0xFFf56961),
      this.textColor = Colors.white,
      this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null
                ? const SizedBox.shrink()
                : Image.asset(
                    image!,
                    height: 20,
                  ),
            image == null
                ? const SizedBox.shrink()
                : const SizedBox(
                    width: 8,
                  ),
            Text(
              title,
              style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
