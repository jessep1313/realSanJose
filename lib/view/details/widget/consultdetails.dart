import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/custombutton.dart';
import 'package:swastha_doctor_flutter/common/widget/customtextfield.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';

class ConsultDetails extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.question_mark_outlined,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Consulting Details",
                style: TextStyle(
                    color: AppColor.textPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              thickness: 0.4,
            ),
          ),
          Text(
            "For her son, 3 years old",
            style: TextStyle(color: AppColor.textPrimaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "I think my child has been exposed to malaria what shoukd I do for it ? Any remedies to cause this quickly?",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Uploaded May 12 2024",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Write an Answer',
                                    style: TextStyle(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 18),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      context.pop();
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Mediaction Name',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                  color: Colors.grey.withOpacity(0.2),
                                  hintText: "",
                                  controller: TextEditingController()),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Optional Note',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 120,
                                child: TextFormField(
                                  onTapOutside: (e) {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus &&
                                        currentFocus.focusedChild != null) {
                                      currentFocus.focusedChild?.unfocus();
                                    }
                                  },
                                  expands: true,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  controller: TextEditingController(),
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey.withOpacity(0.2),
                                      filled: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      hintText: "",
                                      hintMaxLines: 1,
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                      alignLabelWithHint: true,
                                      labelStyle: const TextStyle(
                                        color: Colors.white,
                                      )),
                                  textAlignVertical: TextAlignVertical.top,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Spacer(),
                              CustomButton(
                                color: AppColor.appThemeColor,
                                title: "Write Answer",
                                ontap: () {
                                  context.pop();
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "Write an answer",
                  style:
                      TextStyle(color: AppColor.textPrimaryColor, fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "My Answer",
            style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Answered 01:25 PM May 12 2024",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin a nisl quis justo auctor lacinia. Pellentesque iaculis mi mi, id bibendum tortor condimentum sagittis.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Prescription",
            style: TextStyle(color: AppColor.textPrimaryColor, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin a nisl quis justo auctor lacinia. Pellentesque iaculis mi mi, id bibendum tortor condimentum sagittis.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
