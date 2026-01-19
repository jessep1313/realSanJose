import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/provider/servicemanagementprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/appconstants.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/availabletimesection.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/personalcallsection.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/widget/sendmessagesection.dart';

class AvailabletimeselectScreen extends ConsumerStatefulWidget {
  static var routeName = "/availabletimeselect";
  int index;

  AvailabletimeselectScreen(this.index, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AvailabletimeselectScreenState();
}

class AvailabletimeselectScreenState
    extends ConsumerState<AvailabletimeselectScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final status= ref
        .watch(serviceMangementProvider)
        .weekslistStatus[widget.index];
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          title: Text(daysName[widget.index]),
          actions: [
            GestureDetector(
              onTap: () {
                context.push(NotificationScreen.routeName);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                      children: [
                        Row(
                          children: [
                            Text(
                              status
                                  ? "Active"
                                  : "InActive",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColor.textPrimaryColor),
                            ),
                            Spacer(),
                            Switch(
                              activeColor: AppColor.appAlternateColor,
                              value: status,
                              onChanged: (value) {
                                ref
                                    .read(serviceMangementProvider)
                                    .changeWeekStatus(widget.index, value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: ref
                              .watch(serviceMangementProvider)
                              .scheduleList
                              .length,
                          itemBuilder: (context, index) {
                            final time = ref
                                .read(serviceMangementProvider)
                                .scheduleList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("From"),
                                          DropdownButton(
                                            underline: SizedBox(),
                                            elevation: 0,
                                            isExpanded: false,
                                            dropdownColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            value: time.from,
                                            items: ref
                                                .read(serviceMangementProvider)
                                                .items
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              ref
                                                  .read(
                                                      serviceMangementProvider)
                                                  .onChangedDropDown(
                                                      index, value!);
                                            },
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("To"),
                                          DropdownButton(
                                            underline: SizedBox(),
                                            value: time.to,
                                            items: ref
                                                .read(serviceMangementProvider)
                                                .items
                                                .map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              ref
                                                  .read(
                                                      serviceMangementProvider)
                                                  .onChangedDropDownTo(
                                                      index, value!);
                                            },
                                          )
                                        ],
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            ref
                                                .read(serviceMangementProvider)
                                                .deleteSchedule(time.index);
                                          },
                                          child: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: CustomButton(
                            color: AppColor.appThemeColor,
                            title: "Add Time",
                            ontap: () {
                              ref.read(serviceMangementProvider).dropdownvalue[
                                  ref
                                      .read(serviceMangementProvider)
                                      .dropdownvalue
                                      .length] = "1 PM";
                              ref.read(serviceMangementProvider).addToSchedule(
                                  ref
                                      .read(serviceMangementProvider)
                                      .dropdownvalue
                                      .length);
                            },
                          ),
                        )
                      ],
                    ),
                  )),
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
