import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class CustomCardSection extends ConsumerWidget {
  String image;
  String title;
  String subtitle;
  VoidCallback onTap;

  CustomCardSection(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: Column(
          children: [
            SvgPicture.asset(
              image,
              color: AppColor.appThemeColor,
              height: 45,
              width: 45,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black54),
            ),
            subtitle.isEmpty
                ? SizedBox.shrink()
                : Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
          ],
        ),
      ),
    );
  }
}
