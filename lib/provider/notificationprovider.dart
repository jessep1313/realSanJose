import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/notification.dart';

final notificationProvider = ChangeNotifierProvider(
  (ref) => NotifcationProvider(),
);

class NotifcationProvider with ChangeNotifier {
  var notificationList = [
    NotificationModel("assets/images/specialist1.jpg", "Hello Willam Shareley",
        "Let\'s get started the user experience"),
    NotificationModel(
        "assets/images/specialist3.jpg",
        "Add appointments in your finger tip",
        "Make appointment with your doctor"),
    NotificationModel("assets/images/specialist6.jpg", "Easy Access",
        "Let\'s get started the user experience"),
    NotificationModel("assets/images/specialist7.jpg", "Let make it together",
        "Let\'s get started the user experience"),
  ];
}
