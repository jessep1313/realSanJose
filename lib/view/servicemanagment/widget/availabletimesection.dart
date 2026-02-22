import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/provider/servicemanagementprovider.dart';
import 'package:real_san_jose/view/servicemanagment/widget/availabletimeselect.dart';

import '../../../common/widget/customtextfield.dart';
import '../../../utils/appcolor.dart';

class AvailableTimeSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeksList = ref.watch(serviceMangementProvider).weekslist;
    final weeksStatusList = ref.watch(serviceMangementProvider).weekslistStatus;
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: AppColor.appThemeColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Available Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final week = weeksList[index];
                  final weekStatus = weeksStatusList[index];
                  return GestureDetector(
                    onTap: () {
                      context.push(AvailabletimeselectScreen.routeName,extra: index);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25,
                          ),
                          color: weekStatus
                              ? AppColor.appThemeColor
                              : Colors.transparent),
                      child: Center(
                          child: Text(
                        week,
                        style: TextStyle(
                            color:weekStatus ? Colors.white : Colors.black),
                      )),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: AppColor.appThemeColor),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0, top: 10),
              child: SizedBox(
                height: 100,
                child: TextFormField(
                  onTapOutside: (e) {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      currentFocus.focusedChild?.unfocus();
                    }
                  },
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: TextEditingController(),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0),
                          borderRadius: BorderRadius.circular(15)),
                      hintText:
                          "30 minutes call durations. Get first response within 4 hours",
                      hintMaxLines: 4,
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      )),
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
