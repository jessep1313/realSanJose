import 'package:awesome_circular_chart/awesome_circular_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/searchsection.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/consulthistory/consulthistoryscreen.dart';
import 'package:real_san_jose/view/home/widget/customcardsection.dart';
import 'package:real_san_jose/view/home/widget/headersection.dart';
import 'package:real_san_jose/view/patient/patientscreen.dart';
import 'package:real_san_jose/view/report/reportscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends ConsumerWidget {
  static var routeName = "/homescreen";
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(200.0, AppColor.appThemeColor,
              rankKey: 'Q1'),
          new CircularSegmentEntry(50.0, AppColor.cardColor, rankKey: 'Q2'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
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
                          const HeaderSection(),
                          const SizedBox(height: 10),
                          const SearchSection(),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              context.push(ReportScreen.routeName);
                            },
                            child: Row(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Consults for today,',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppColor.textPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      '6 of 10 Completed',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  height: 80,
                                  width: 80,
                                  padding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                      color: AppColor.cardColor,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: AnimatedCircularChart(
                                    key: _chartKey,
                                    duration: Duration(milliseconds: 400),
                                    edgeStyle: SegmentEdgeStyle.round,
                                    holeLabel: "80",
                                    holeRadius: 15,
                                    labelStyle: TextStyle(
                                        color: AppColor.appThemeColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    size: const Size(100.0, 100.0),
                                    initialChartData: data,
                                    chartType: CircularChartType.Radial,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://cninfotech.com/portfolio/?action=mobile'));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    Image.asset('assets/images/medical.jpg')),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon1-01.svg',
                                title: "Request Schedule",
                                subtitle: "10+ New",
                                onTap: () {
                                  ref
                                      .watch(configProvider)
                                      .dashboardController
                                      .jumpToTab(1);
                                },
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon2-02.svg',
                                title: "Consult History",
                                subtitle: "10+ New",
                                onTap: () {
                                  context.push(ConsultHistoryScreen.routeName);
                                },
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon3-03.svg',
                                title: "Patients List",
                                subtitle: "10+ New",
                                onTap: () {
                                  context.push(PatientScreen.routeName);
                                },
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon4-04.svg',
                                title: "Appoint Report",
                                subtitle: "10+ New",
                                onTap: () {
                                  context.push(ReportScreen.routeName);
                                },
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://cninfotech.com/portfolio/?action=mobile'));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    Image.asset('assets/images/banner2.jpg')),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
