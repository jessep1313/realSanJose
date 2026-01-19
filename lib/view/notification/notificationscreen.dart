import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/provider/notificationprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';

class NotificationScreen extends ConsumerWidget {
  static var routeName = "/notification";

  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notification = ref.watch(notificationProvider).notificationList;
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          title: const Text("Notificaitons"),
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
                    child: ListView.builder(
                        primary: true,
                        shrinkWrap: true,
                        itemCount: notification.length,
                        itemBuilder: (BuildContext context, index) {
                          final notifications = notification[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {},
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(),
                              padding: const EdgeInsets.only(
                                right: 20,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 36,
                              ),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.white,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 10),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: SizedBox(
                                        height: 45,
                                        width: 45,
                                        child: Image.asset(
                                          notifications.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notifications.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColor.textPrimaryColor,
                                                  fontSize: 14),
                                            ),
                                            Text(notifications.subtitle,
                                                style: TextStyle(
                                                    color:
                                                        AppColor.appThemeColor,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      color: Colors.white38,
                      title: "Mark as Read",
                      ontap: () {},
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      color: Colors.white38,
                      title: "Clear All",
                      ontap: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
