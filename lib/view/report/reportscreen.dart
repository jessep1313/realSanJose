import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/buttomsheet.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/notification/notificationscreen.dart';

class ReportScreen extends ConsumerStatefulWidget {
  static var routeName = "/reportscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ReportScreenState();
}

class ReportScreenState extends ConsumerState<ReportScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Report'),
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
                  color: AppColor.textPrimaryColor
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
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        AspectRatio(
                          aspectRatio: 1.3,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback:
                                    (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 60,
                              sections: showingSections(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.video_call,
                                  size: 20,
                                  color: AppColor.appThemeColor,
                                ),
                                Text(
                                  "Video Call",
                                  style: TextStyle(
                                      color: AppColor.appThemeColor,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.messenger_outline_outlined,
                                  size: 20,
                                ),
                                Text(
                                  "Messages",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: AppColor.appAlternateColor,
                                  size: 20,
                                ),
                                Text(
                                  "Audio Call",
                                  style: TextStyle(
                                      color: AppColor.appAlternateColor,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.messenger_outline_outlined,
                                  size: 20,
                                ),
                                Text(
                                  "Live Chat",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 40),
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Video Call",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "1470",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Audio Call",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "500+",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Live Chat",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "980",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Messages",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "450",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
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
                  "All your check up report wiil be shown here",
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

  List<PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 13.0;
      final radius = isTouched ? 100.0 : 90.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.black,
            value: 13,
            title: '600\nMessage',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.teal,
            value: 30,
            title: '1400\nAudio Call',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue,
            value: 40,
            title: '2000\nVideo Call',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.black38,
            value: 17,
            title: '800\nLive Chat',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
