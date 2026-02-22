import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/custombutton.dart';
import 'package:real_san_jose/common/widget/customtextfield.dart';
import 'package:real_san_jose/provider/accountprovider.dart';
import 'package:real_san_jose/utils/decoration.dart';

import '../../common/widget/borderradius.dart';
import '../../utils/appcolor.dart';
import '../notification/notificationscreen.dart';

class BankAccountScreen extends ConsumerWidget {
  static var routeName = "/bankaccountsecreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: bgDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.appBackgroundColor,
          title: const Text("Add Bank Account"),
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
                            Image.asset("assets/images/visa.png"),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Securely enter bank account details below to have payments from patients automatically deposited inot your account",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.textPrimaryColor),
                              ),
                            ),
                            const Text(
                              "Firstname",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                hintText: "",
                                controller: TextEditingController()),
                            const Text(
                              "Lastname",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                hintText: "",
                                controller: TextEditingController()),
                            const Text(
                              "Account Type",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            Row(
                              children: [
                                Radio<int>(
                                  value: 1,
                                  activeColor: AppColor.appAlternateColor,
                                  groupValue:
                                  ref
                                      .watch(accountProvider)
                                      .selectedOption,
                                  onChanged: (value) {
                                    ref.watch(accountProvider).onChnaged(
                                        value!);
                                  },
                                ),
                                Text(
                                  "Checking",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: AppColor.textPrimaryColor),
                                ),
                                Radio<int>(
                                  value: 2,
                                  activeColor: AppColor.appAlternateColor,
                                  groupValue:
                                  ref
                                      .watch(accountProvider)
                                      .selectedOption,
                                  onChanged: (value) {
                                    ref.watch(accountProvider).onChnaged(
                                        value!);
                                  },
                                ),
                                Text("Saving",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: AppColor.textPrimaryColor)),
                              ],
                            ),
                            Text("Account Number",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                hintText: "",
                                controller: TextEditingController()),
                            const Text(
                              "Routing Number",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColor.textPrimaryColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                                hintText: "",
                                controller: TextEditingController()),
                            Row(
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: AppColor.appAlternateColor,
                                  value: ref
                                      .watch(accountProvider)
                                      .isSelected,
                                  onChanged: (value) {
                                    ref
                                        .watch(accountProvider)
                                        .onChnagedCheckBox(value!);
                                  },
                                ),
                                Expanded(
                                  child: const Text(
                                    " I understand and accept the payment terms and I authorize the application to deposit funds into my account.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
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
                  title: "Save Account",
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
