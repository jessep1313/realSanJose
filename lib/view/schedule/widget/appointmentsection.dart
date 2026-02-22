import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/buttomsheet.dart';
import 'package:real_san_jose/model/schedule.dart';
import 'package:real_san_jose/provider/scheduleprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/details/detailscreen.dart';

class AppointmentSection extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AppointmentSectionState();
}

class AppointmentSectionState extends ConsumerState<AppointmentSection> {
  @override
  Widget build(BuildContext context) {
    final scheduleList = ref.read(scheduleProvider).scheduleList;
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final schedule = scheduleList[index];
          return GestureDetector(
            onTap: () {
              context.push(DetailsScreen.routeName, extra: schedule);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        schedule.image,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.callType,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
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
                            color: AppColor.textPrimaryColor, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    schedule.status == Status.progress
                        ? "Still in progress"
                        : schedule.status == Status.completed
                            ? "Completed"
                            : schedule.status == Status.accepted
                                ? "Accepted"
                                : schedule.status == Status.unconfirmed
                                    ? "Unconfirmed"
                                    : "Completed",
                    style: TextStyle(
                        color: schedule.status == Status.progress
                            ? Colors.orange
                            : schedule.status == Status.completed
                                ? AppColor.appThemeColor
                                : schedule.status == Status.accepted
                                    ? Colors.red
                                    : schedule.status == Status.unconfirmed
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
        itemCount: scheduleList.length);
  }
}
