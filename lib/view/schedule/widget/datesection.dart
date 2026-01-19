import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:swastha_doctor_flutter/provider/scheduleprovider.dart';

import '../../../utils/appcolor.dart';

class DateSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(scheduleProvider).isVisible;
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isVisible
          ? HorizontalWeekCalendar(
              monthFormat: "MMMM yyyy",
              minDate: DateTime(2023, 12, 31),
              maxDate: DateTime(2026, 1, 31),
              initialDate: DateTime(2024, 1, 15),
              weekStartFrom: WeekStartFrom.Sunday,
              activeBackgroundColor: AppColor.appThemeColor,
              activeTextColor: Colors.white,
              borderRadius: BorderRadius.circular(15),
              monthColor: AppColor.textPrimaryColor,
              inactiveBackgroundColor: Colors.transparent,
              inactiveTextColor: Colors.black,
              disabledTextColor: Colors.grey,
              disabledBackgroundColor: Colors.transparent,
              activeNavigatorColor: Colors.black,
              inactiveNavigatorColor: Colors.black,
            )
          : SizedBox.shrink(),
    );
  }
}
