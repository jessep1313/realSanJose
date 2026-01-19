import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swastha_doctor_flutter/model/schedule.dart';

final scheduleProvider = ChangeNotifierProvider.autoDispose<ScheduleProvider>(
  (ref) => ScheduleProvider(),
);

class ScheduleProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  bool isVisible = true;

  void onScroll(ScrollController controller){
    scrollController=controller;
    notifyListeners();
  }
  void setVisible(bool value){
    isVisible=value;
    notifyListeners();
  }
  var scheduleList = [
    Schedule('assets/images/specialist1.jpg', 'Video call', 'Ram Kumar Sharma',
        '1 hrs remaining', Status.progress),
    Schedule('assets/images/specialist2.jpg', 'Audio call', 'Diwas Raut',
        'Received at 09:45 AM', Status.completed),
    Schedule('assets/images/specialist3.jpg', 'Free Consult', 'Devendra Aryal',
        '08:00 PM - 08:30 PM', Status.accepted),
    Schedule('assets/images/specialist4.jpg', 'Video call', 'Roshan Aryal',
        '1 hrs remaining', Status.unconfirmed),
    Schedule('assets/images/specialist5.jpg', 'Chat', 'Rita Rimal',
        '4 hrs remain to confirm', Status.completed),
    Schedule('assets/images/specialist6.jpg', 'Audio call', 'Amit Giri',
        'Received at 7:45 PM', Status.progress),
    Schedule('assets/images/specialist1.jpg', 'Video call', 'Ram Kumar Sharma',
        '1 hrs remaining', Status.progress),
    Schedule('assets/images/specialist2.jpg', 'Audio call', 'Diwas Raut',
        'Received at 09:45 AM', Status.completed),
    Schedule('assets/images/specialist3.jpg', 'Free Consult', 'Devendra Aryal',
        '08:00 PM - 08:30 PM', Status.accepted),
    Schedule('assets/images/specialist4.jpg', 'Video call', 'Roshan Aryal',
        '1 hrs remaining', Status.unconfirmed),
    Schedule('assets/images/specialist5.jpg', 'Chat', 'Rita Rimal',
        '4 hrs remain to confirm', Status.completed),
    Schedule('assets/images/specialist6.jpg', 'Audio call', 'Amit Giri',
        'Received at 7:45 PM', Status.progress),
  ];
}
