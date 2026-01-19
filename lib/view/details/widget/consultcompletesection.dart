import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class ConsultCompleteSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.reviews,
              color: Colors.grey,
            ),
            SizedBox(
              width: 8,
            ),
            const Text(
              "Review",
              style: TextStyle(
                  color: AppColor.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 0.4,
            color: Colors.white,
          ),
        ),
        RatingBar.builder(
          initialRating: 5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            size: 15,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 0.4,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          width: double.infinity,
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin a nisl quis justo auctor lacinia. Pellentesque iaculis mi mi, id bibendum tortor condimentum sagittis.",
            style: TextStyle(fontSize: 12),
          ),
        )
      ],
    );
  }
}
