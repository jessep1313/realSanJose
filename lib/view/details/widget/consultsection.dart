import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/buttomsheet.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/callscreen/callscreen.dart';
import 'package:real_san_jose/view/chatdetails/chatdetailscreen.dart';

class ConsultSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Consult",
                style: TextStyle(
                    color: AppColor.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              thickness: 0.4,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  color: AppColor.appAlternateColor,
                  title: 'Consult Now',
                  ontap: () {
                    context.push(CallScreen.routeName);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  context.push(ChatDetailScreen.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.appThemeColor),
                  child: Icon(
                    Icons.messenger_outline_outlined,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
