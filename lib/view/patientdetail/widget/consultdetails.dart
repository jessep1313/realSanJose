import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/common/widget/customtextfield.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class ConsultDetailsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.question_mark_outlined,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Consulting Details",
                style: TextStyle(
                    color: AppColor.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              thickness: 0.4,
            ),
          ),
          Text(
            "For her son, 3 years old",
            style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "I think my child has been exposed to malaria what shoukd I do for it ? Any remedies to cause this quickly?",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Uploaded May 12 2024",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
