import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/provider/patientprovider.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/notification/notificationscreen.dart';
import 'package:real_san_jose/view/patientdetail/patientdetailscreen.dart';

import '../../model/schedule.dart';

class PatientScreen extends ConsumerStatefulWidget {
  static var routeName = "/patientscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PatientScreenState();
}

class PatientScreenState extends ConsumerState<PatientScreen> {
  @override
  Widget build(BuildContext context) {
    final patientList = ref.read(pateintProvider).patientList;
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Patients'),
          elevation: 0,
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
                  color: Colors.black,
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
                        ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              final patient = patientList[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(PatientDetailsScreen.routeName);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            patient.image,
                                            height: 55,
                                            width: 55,
                                            fit: BoxFit.cover,
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            patient.name,
                                            style: TextStyle(
                                                color: AppColor.appThemeColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                patient.gender,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                patient.dobYear,
                                                style: TextStyle(
                                                    color:
                                                        AppColor.appThemeColor,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.red,
                                                size: 15,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                patient.number,
                                                style: const TextStyle(
                                                    color: AppColor
                                                        .textPrimaryColor,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 15,
                              );
                            },
                            itemCount: patientList.length),
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
