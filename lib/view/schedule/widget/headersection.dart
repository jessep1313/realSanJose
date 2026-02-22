import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/notification/notificationscreen.dart';

class HeaderSection extends ConsumerWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            foregroundImage: AssetImage('assets/images/specialist.jpg'),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Dr,',
                style: TextStyle(
                    fontSize: 15,
                    color: AppColor.textPrimaryColor,
                    fontWeight: FontWeight.normal),
              ),
              const Text(
                'How are you today?',
                style:
                    TextStyle(fontSize: 12, color: AppColor.textPrimaryColor),
              ),
            ],
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
                color: AppColor.textPrimaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
