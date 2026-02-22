import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/provider/accountprovider.dart';
import 'package:real_san_jose/provider/editprofileprovider.dart';
import 'package:real_san_jose/utils/decoration.dart';

import '../../common/widget/borderradius.dart';
import '../../utils/appcolor.dart';
import '../notification/notificationscreen.dart';

class EditProfileScreen extends ConsumerWidget {
  static var routeName = "/editprofilescreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(editProfileProvider).selectedImage;
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          title: const Text("Edit profile"),
          actions: [
            GestureDetector(
              onTap: () {
                context.push(NotificationScreen.routeName);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(
                  Icons.notifications_none_outlined,
                  size: 30,
                  color: AppColor.textPrimaryColor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(editProfileProvider).getImageFromGallery();
                          },
                          child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Stack(
                                  children: [
                                    selectedImage.isEmpty
                                        ? Image.asset(
                                            "assets/images/specialist2.jpg",
                                            fit: BoxFit.cover,
                                            width: 90,
                                            height: 90,
                                          )
                                        : Image.file(
                                            File(selectedImage),
                                            fit: BoxFit.cover,
                                            width: 90,
                                            height: 90,
                                          ),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 30,
                                        width: double.infinity,
                                        color: Colors.black45,
                                        child: Center(
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Firstname",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const Text(
                          "Lastname",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const Text(
                          "Username",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              activeColor: AppColor.appAlternateColor,
                              groupValue:
                                  ref.watch(accountProvider).selectedOption,
                              onChanged: (value) {
                                ref.watch(accountProvider).onChnaged(value!);
                              },
                            ),
                            Text(
                              "Male",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            Radio<int>(
                              value: 2,
                              activeColor: AppColor.appAlternateColor,
                              groupValue:
                                  ref.watch(accountProvider).selectedOption,
                              onChanged: (value) {
                                ref.watch(accountProvider).onChnaged(value!);
                              },
                            ),
                            Text(
                              "Female",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            Radio<int>(
                              value: 3,
                              activeColor: AppColor.appAlternateColor,
                              groupValue:
                                  ref.watch(accountProvider).selectedOption,
                              onChanged: (value) {
                                ref.watch(accountProvider).onChnaged(value!);
                              },
                            ),
                            Text(
                              "Others",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Mobile Number",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 14, color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextField(
                            hintText: "", controller: TextEditingController()),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: CustomButton(
                  color: Colors.white.withOpacity(0.3),
                  title: "Save Profile",
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
