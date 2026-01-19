import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/addbankaccount/bankaccountscreen.dart';
import 'package:swastha_doctor_flutter/view/editprofile/editprofilescreen.dart';
import 'package:swastha_doctor_flutter/view/home/widget/customcardsection.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';
import 'package:swastha_doctor_flutter/view/servicemanagment/servicemanagementscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilescreen extends ConsumerWidget {
  static var routeName = "/profilescreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Profile'),
          elevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          actions: [
            GestureDetector(
              onTap: () {
                context.push(NotificationScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(Icons.notifications_none_outlined,
                    size: 30, color: AppColor.textPrimaryColor),
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
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  foregroundImage: AssetImage(
                                      'assets/images/specialist.jpg'),
                                  radius: 35,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dr.Smith Rowe',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: AppColor.textPrimaryColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'smith@gmail.com',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          '+1389995050',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    context.push(EditProfileScreen.routeName);
                                  },
                                  child: Card(
                                    color: AppColor.appThemeColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                          'assets/images/edit_icon.png',
                                          color: Colors.white,
                                          height: 15,
                                          width: 15),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon5-05.svg',
                                title: "Bank Account",
                                subtitle: "",
                                onTap: () {
                                  context.push(BankAccountScreen.routeName);
                                },
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: CustomCardSection(
                                image: 'assets/images/icon6-06.svg',
                                title: "Service Management",
                                subtitle: "",
                                onTap: () {
                                  context
                                      .push(ServiceManagementScreen.routeName);
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
                                    Image.asset('assets/images/medical.jpg')),
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
