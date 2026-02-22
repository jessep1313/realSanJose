import 'package:flutter/cupertino.dart';
import 'package:real_san_jose/utils/appcolor.dart';

BoxDecoration bgDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFFFFFFF), // Pantone 293
        Color(0xFFFFFFFF), // Pantone 582
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

