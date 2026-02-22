import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/provider/chatprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/callscreen/callscreen.dart';

import '../../common/widget/borderradius.dart';

class ChatDetailScreen extends ConsumerWidget {
  static var routeName = "/chatdetailscreen";

  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatList = ref
        .watch(chatProvider)
        .messages;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(right: 16, top: 30),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              Container(
                height: 40,
                width: 40,
                //padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.appThemeColor,
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/specialist.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Nile Jordan",
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.textPrimaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push(CallScreen.routeName);
                },
                child: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  context.push(CallScreen.routeName);
                },
                child: Icon(
                  Icons.video_call,
                  color: AppColor.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25))),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: chatList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final messages = chatList[index];
                return Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 10),
                  child: Align(
                    alignment: (messages.messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Column(
                      crossAxisAlignment: messages.messageType == "receiver"
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 5),
                          child: Text(
                            messages.time,
                            textAlign: (messages.messageType == "receiver"
                                ? TextAlign.left
                                : TextAlign.right),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: messages.messageType == "receiver"
                                ? const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(15))
                                : const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0)),
                            color: (messages.messageType == "receiver"
                                ? Colors.grey.withOpacity(0.2)
                                : AppColor.appThemeColor),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            messages.messageContent,
                            style: TextStyle(
                              fontSize: 15,
                              color: (messages.messageType == "receiver"
                                  ? Colors.black
                                  : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.grey.withOpacity(0.2),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.attach_file,
                          color: AppColor.textPrimaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          onTapOutside: (value) {
                            FocusScopeNode currentFocus =
                            FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus &&
                                currentFocus.focusedChild != null) {
                              currentFocus.focusedChild?.unfocus();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Type your message...",
                              contentPadding: const EdgeInsets.all(10),
                              hintStyle: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.transparent),
                                  borderRadius: borderRadius()),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Colors.transparent),
                                  borderRadius: borderRadius()),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0))),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(
                          Icons.send,
                          color: AppColor.textPrimaryColor,
                          size: 30,
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
