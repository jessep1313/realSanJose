import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/appcolor.dart';

class CustomListBox extends ConsumerWidget {
  final int id;
  final String title;
  final String location;
  final String price;
  final String image;
  final bool isFavourtie;
  final VoidCallback onTap;

  const CustomListBox(this.id, this.title, this.location, this.price,
      this.image, this.onTap, this.isFavourtie,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
          color: AppColor.cardColor, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: isFavourtie
                                ? AppColor.appAlternateColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: isFavourtie
                              ? Colors.white
                              : AppColor.textPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColor.appThemeColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColor.textPrimaryColor,
                          size: 13,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          location,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColor.textPrimaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    price,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColor.appAlternateColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
