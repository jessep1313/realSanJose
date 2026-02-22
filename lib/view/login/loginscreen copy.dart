import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/borderradius.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/utils/decoration.dart';
import 'package:real_san_jose/view/dashboard/dashboardscreen.dart';
import 'package:real_san_jose/view/forgotpassword/forgotpasswordscreen.dart';
import 'package:real_san_jose/view/login/widget/socialbutton.dart';
import 'package:real_san_jose/view/register/register.dart';

class LoginScreen extends ConsumerWidget {
  static var routeName = "/loginscreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        decoration: bgDecoration(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  //height: MediaQuery.of(context).size.height * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Image.asset('assets/images/logo.jpg')),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Text(
                              'Login to get started.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          'Email/Username',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextField(
                            color: Colors.grey.withOpacity(0.2),
                            hintText: 'Enter email',
                            controller: TextEditingController()),
                        Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextField(
                            color: Colors.grey.withOpacity(0.2),
                            hintText: 'Enter password',
                            controller: TextEditingController()),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  context.push(ForgotPasswordScreen.routeName);
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          title: "Login",
                          ontap: () {
                            context.push(DashboardScreen.routeName);
                          },
                          color: AppColor.appThemeColor,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'OR',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialLogin(
                                image: 'assets/images/59439.png',
                                color: Colors.blue),
                            SizedBox(
                              width: 20,
                            ),
                            SocialLogin(
                                image: 'assets/images/google.png',
                                color: Colors.red),
                            SizedBox(
                              width: 20,
                            ),
                            SocialLogin(
                                image: "assets/images/twitter.png",
                                color: Colors.black)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push(RegisterScreen.routeName);
                      },
                      child: Text(
                        ' Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
