import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class AdditionalInformationSection extends ConsumerWidget {
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
                Icons.medical_information_rounded,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Additional Information",
                style: TextStyle(
                    color: AppColor.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text("Diagonased Condition",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
          SizedBox(
            height: 5,
          ),
          Text("None",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
          SizedBox(
            height: 10,
          ),
          Text("Medication",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
          SizedBox(
            height: 5,
          ),
          Text("None",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
          SizedBox(
            height: 10,
          ),
          Text("Allergies",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
          SizedBox(
            height: 5,
          ),
          Text("None",
              style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 12)),
        ],
      ),
    );
  }
}
