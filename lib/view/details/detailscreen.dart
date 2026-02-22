import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/model/schedule.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/details/widget/additionalinforamtion.dart';
import 'package:real_san_jose/view/details/widget/consultcompletesection.dart';
import 'package:real_san_jose/view/details/widget/consultdetails.dart';
import 'package:real_san_jose/view/details/widget/consultsection.dart';
import 'package:real_san_jose/view/details/widget/patientdetailsection.dart';
import 'package:real_san_jose/view/details/widget/vistingsection.dart';

import '../notification/notificationscreen.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  static var routeName = "/detailscreen";
  Schedule schedule;

  DetailsScreen({super.key, required this.schedule});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DetailsScreenState();
}

class DetailsScreenState extends ConsumerState<DetailsScreen> {
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
          actions: [
            GestureDetector(
              onTap: () {
                context.push(NotificationScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        PatientDetailSection(),
                        SizedBox(
                          height: 25,
                        ),
                        ConsultSection(),
                        SizedBox(
                          height: 25,
                        ),
                        VistingSection(),
                        SizedBox(
                          height: 25,
                        ),
                        ConsultDetails(),
                        SizedBox(
                          height: 25,
                        ),
                        AdditionalInformation(),
                        SizedBox(
                          height: 30,
                        ),
                        widget.schedule.status == Status.progress
                            ? Center(
                                child: Text(
                                  "Cancel Appoinment",
                                ),
                              )
                            : widget.schedule.status == Status.accepted
                                ? Center(
                                    child: Text(
                                      "Are you done ? Finsih Consult Now.",
                                    ),
                                  )
                                : widget.schedule.status == Status.unconfirmed
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                              color: AppColor.appThemeColor,
                                              title: "Accept",
                                              ontap: () {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: CustomButton(
                                              title: "Reject",
                                              ontap: () {},
                                            ),
                                          )
                                        ],
                                      )
                                    : ConsultCompleteSection(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "Respect Patients Detail and Privacy following the protocols",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
