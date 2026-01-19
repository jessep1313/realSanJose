import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/view/chatdetails/chatdetailscreen.dart';

import '../../../provider/chatprovider.dart';

class Story extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationList = ref.read(chatProvider).conversationList;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemCount: conversationList.length,
        itemBuilder: (context, index) {
          final conversation = conversationList[index];
          return GestureDetector(
            onTap: () {
              context.push(ChatDetailScreen.routeName);
            },
            child: Container(
              width: 80,
              color: Colors.transparent,
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.asset(
                          conversation.image,
                          fit: BoxFit.cover,
                          width: 55,
                          height: 55,
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
                  ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    maxLines: 1,
                    conversation.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
