import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/login/loginscreen.dart';
import 'package:swastha_doctor_flutter/view/register/register.dart';

import '../../provider/onboardingprovider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  static var routeName = "/onboardingscreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      OnBoardingScreenState();
}

class OnBoardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final currentIndex = ref.watch(onboardingProvider).currentIndex;
    final pages = ref.watch(onboardingProvider).pages;
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius(),
                  color: Colors.white,
                ),
                width: width,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.7,
                      child: PageView.builder(
                        controller: controller,
                        onPageChanged: (index) {
                          ref.watch(onboardingProvider).onChagedIndex(index);
                        },
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  pages[index]['image']!,
                                  height: 300,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  pages[index]['title']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.appThemeColor),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Text(
                                    pages[index]['description']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                          height: 8,
                          width: currentIndex == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? AppColor.appThemeColor
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Colors.white, width: 2))),
                            onPressed: () {
                              context.push(LoginScreen.routeName);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: CustomButton(
                          title: "Sign Up",
                          ontap: () {
                            context.push(RegisterScreen.routeName);
                          },
                          color: Colors.white,
                          textColor: AppColor.appThemeColor,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'By Continuing, you agree to the the Terms and Conditon',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
