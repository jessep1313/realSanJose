import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/common/widget/buttomsheet.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/chatdetails/chatdetailscreen.dart';

import '../../../provider/chatprovider.dart';

class Conversation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationList = ref.read(chatProvider).conversationList;
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          final conversation = conversationList[index];
          return GestureDetector(
            onTap: () {
              context.push(ChatDetailScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.asset(
                            conversation.image,
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          )),
                      conversation.isOnline
                          ? Positioned(
                              right: 5,
                              child: Container(
                                height: 10,
                                width: 10,
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conversation.title,
                        style: TextStyle(
                            color: AppColor.appThemeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        conversation.message,
                        style: TextStyle(
                            fontWeight: conversation.isOnline
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Text(
                    conversation.time,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 15,
          );
        },
        itemCount: conversationList.length);
  }
}
