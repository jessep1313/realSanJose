import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/customtextfield.dart';
import '../../../utils/appcolor.dart';

class SendMessageSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.messenger_outline_outlined,
                  size: 20,
                  color: AppColor.appThemeColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Send Message",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Service Price (240 Consulted)",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: AppColor.appThemeColor),
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
                color: Colors.grey.withOpacity(0.2),
                hintText: "\$45",
                controller: TextEditingController()),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Rate per 30 minutes",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                    color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: AppColor.appThemeColor),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0, top: 10),
              child: SizedBox(
                height: 100,
                child: TextFormField(
                  onTapOutside: (e) {
                    FocusScopeNode currentFocus = FocusScope.of(context);
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade300, width: 0),
                          borderRadius: BorderRadius.circular(15)),
                      hintText:
                          "Send multiple messages/attacements. Get first response within 4 hours",
                      hintMaxLines: 4,
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      )),
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
