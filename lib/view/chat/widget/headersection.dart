import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:swastha_doctor_flutter/utils/appcolor.dart';
import 'package:swastha_doctor_flutter/view/notification/notificationscreen.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          const Text(
            'Message',
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.push(NotificationScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
