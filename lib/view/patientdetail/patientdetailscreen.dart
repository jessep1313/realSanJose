import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/model/schedule.dart';
import 'package:swastha_doctor_flutter/provider/scheduleprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/details/detailscreen.dart';
import 'package:swastha_doctor_flutter/view/details/widget/patientdetailsection.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';
import 'package:swastha_doctor_flutter/view/patientdetail/widget/additionalinforamtion.dart';
import 'package:swastha_doctor_flutter/view/patientdetail/widget/consultdetails.dart';
import 'package:swastha_doctor_flutter/view/patientdetail/widget/patientdetailsection.dart';
import 'package:swastha_doctor_flutter/view/patientdetail/widget/vistingsection.dart';

class PatientDetailsScreen extends ConsumerStatefulWidget {
  static var routeName = "/patientdetailscreen";

  PatientDetailsScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PateientDetailsState();
}

class PateientDetailsState extends ConsumerState<PatientDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final history = ref.read(scheduleProvider).scheduleList;
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
                        PatientDetail(),
                        SizedBox(
                          height: 25,
                        ),
                        VistingTime(),
                        SizedBox(
                          height: 25,
                        ),
                        ConsultDetailsSection(),
                        SizedBox(
                          height: 25,
                        ),
                        AdditionalInformationSection(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Consult History",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              final schedule = history[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(DetailsScreen.routeName,
                                      extra: schedule);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                                            schedule.image,
                                            height: 55,
                                            width: 55,
                                            fit: BoxFit.cover,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            schedule.callType,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                          Text(
                                            schedule.name,
                                            style: TextStyle(
                                                color: AppColor.appThemeColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            schedule.time,
                                            style: TextStyle(
                                                color:
                                                    AppColor.textPrimaryColor,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        schedule.status == Status.progress
                                            ? "Still in progress"
                                            : schedule.status ==
                                                    Status.completed
                                                ? "Completed"
                                                : schedule.status ==
                                                        Status.accepted
                                                    ? "Accepted"
                                                    : schedule.status ==
                                                            Status.unconfirmed
                                                        ? "Unconfirmed"
                                                        : "Completed",
                                        style: TextStyle(
                                            color: schedule.status ==
                                                    Status.progress
                                                ? Colors.orange
                                                : schedule.status ==
                                                        Status.completed
                                                    ? AppColor.appThemeColor
                                                    : schedule.status ==
                                                            Status.accepted
                                                        ? Colors.red
                                                        : schedule.status ==
                                                                Status
                                                                    .unconfirmed
                                                            ? Colors.red
                                                            : Colors.grey,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 15,
                              );
                            },
                            itemCount: 5),
                        SizedBox(
                          height: 20,
                        )
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
