import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/provider/scheduleprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/schedule/widget/appointmentsection.dart';
import 'package:swastha_doctor_flutter/view/schedule/widget/datesection.dart';
import 'package:swastha_doctor_flutter/view/schedule/widget/headersection.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (controller.position.userScrollDirection == ScrollDirection.reverse) {
      if (ref.watch(scheduleProvider).isVisible) {
        ref.read(scheduleProvider).setVisible(false);
      }
    } else if (controller.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!ref.watch(scheduleProvider).isVisible) {
        ref.read(scheduleProvider).setVisible(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: bgDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            //height: MediaQuery.of(context).size.height * 0.9,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColor.appBackgroundColor,
              borderRadius: borderRadius(),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: SafeArea(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          DateSection(),
                          const SizedBox(
                            height: 15,
                          ),
                          AppointmentSection(),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}
