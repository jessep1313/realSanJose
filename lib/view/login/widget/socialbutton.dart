import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialLogin extends ConsumerWidget {
  String image;
  Color color;

  SocialLogin({super.key, required this.image, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Image.asset(
        image,
        height: 20,
        width: 20,
        color: Colors.white,
      ),
    );
  }
}
