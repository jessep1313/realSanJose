import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/common/widget/borderradius.dart';
import 'package:swastha_doctor_flutter/common/widget/searchsection.dart';
import 'package:swastha_doctor_flutter/provider/chatprovider.dart';
import 'package:swastha_doctor_flutter/provider/scheduleprovider.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/utils/decoration.dart';
import 'package:swastha_doctor_flutter/view/chat/widget/conversation.dart';
import 'package:swastha_doctor_flutter/view/chat/widget/headersection.dart';
import 'package:swastha_doctor_flutter/view/chat/widget/story.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';

class ChatScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleList = ref.read(scheduleProvider).scheduleList;
    final conversationList = ref.read(chatProvider).conversationList;
    return Container(
        decoration: bgDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Message'),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColor.appBackgroundColor,
            actions: [
              GestureDetector(
                onTap: () {
                  context.push(NotificationScreen.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        children: [
                          const SearchSection(),
                          SizedBox(
                            height: 10,
                          ),
                          Story(),
                          SizedBox(
                            height: 10,
                          ),
                          Conversation()
                        ],
                      ),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
