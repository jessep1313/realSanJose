import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/common/widget/customtextfield.dart';
import 'package:swastha_doctor_flutter/common/widget/forgotbuttonsheet.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

void showMyBottomSheet(BuildContext context, {bool isLogin = false}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (context) {
      return Container(
          height: double.infinity,
          color: AppColor.appThemeColor,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  right: 0,
                  child: Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      'assets/images/corner_background_wave.png',
                      height: 140,
                    ),
                  )),
              Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.white,
                      size: 30,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Card(
                      shadowColor: Colors.black,
                      child: Image.asset(
                        'assets/icons/logo.jpg',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLogin ? 'Welcome Back' : 'Create an account',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isLogin
                                  ? 'Hello there, sign in to continue'
                                  : 'Enter your detail to create an account',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            isLogin
                                ? const SizedBox.shrink()
                                : CustomTextField(
                                    hintText: 'Name',
                                    controller: TextEditingController()),
                            CustomTextField(
                                hintText: 'Username',
                                controller: TextEditingController()),
                            CustomTextField(
                              hintText: 'Password',
                              controller: TextEditingController(),
                              isPassword: true,
                              textInputType: TextInputType.visiblePassword,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: isLogin
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          forgotPasswordBottomSheet(context);
                                        },
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomButton(
                              title: isLogin ? 'Sign in' : 'Sign up',
                              ontap: () {
                               // context.push(HomeScreen.routeName);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                                'assets/images/background_pattern.png')),
                      )
                    ],
                  ),
                ),
              )
            ],
          ));
    },
  );
}
