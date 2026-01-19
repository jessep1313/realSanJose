import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/common/widget/customtextfield.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/availabletimesection.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/personalcallsection.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/sendmessagesection.dart';

class ServiceManagementScreen extends ConsumerStatefulWidget {
  static var routeName = "/servicemanagement";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ServicemanagementScreenState();
}

class ServicemanagementScreenState
    extends ConsumerState<ServiceManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          title: const Text("Service Management"),
          actions: [
            GestureDetector(
              onTap: () {
                context.push(NotificationScreen.routeName);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 30,
                  color: AppColor.textPrimaryColor,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                //height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: AppColor.appBackgroundColor,
                  borderRadius: borderRadius(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15),
                  child: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SendMessageSection(),
                        SizedBox(
                          height: 20,
                        ),
                        PersonalCallSection(),
                        SizedBox(
                          height: 20,
                        ),
                        AvailableTimeSection()
                      ],
                    )),
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: CustomButton(
                  color: Colors.white.withOpacity(0.3),
                  title: "Save",
                  ontap: () {
                    context.pop();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
