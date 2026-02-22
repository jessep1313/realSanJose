import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/details/detailscreen.dart';

import '../../model/schedule.dart';

class ConsultHistoryScreen extends ConsumerStatefulWidget {
  static var routeName = "/consulthistoryscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ConsultHistoryScreenState();
}

class ConsultHistoryScreenState extends ConsumerState<ConsultHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final scheduleList = ref
        .read(scheduleProvider)
        .scheduleList;
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Consult History'),
          elevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: AppColor.textPrimaryColor,
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
                            Text(
                              "Still in Progress",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: AppColor.textPrimaryColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  final schedule = scheduleList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(DetailsScreen.routeName,
                                          extra: schedule);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              15)),
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
                                                    color: AppColor
                                                        .appThemeColor,
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
                                itemCount: scheduleList.length),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Next Consults",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: AppColor.textPrimaryColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  final schedule = scheduleList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(DetailsScreen.routeName,
                                          extra: schedule);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              15)),
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
                                                    color: AppColor
                                                        .appThemeColor,
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
                                itemCount: 2),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Past Consults",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: AppColor.textPrimaryColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  final schedule = scheduleList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(DetailsScreen.routeName,
                                          extra: schedule);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              15)),
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
                                                    color: AppColor
                                                        .appThemeColor,
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
                                itemCount: 4)
                          ],
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
