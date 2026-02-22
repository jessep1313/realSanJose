import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/model/time.dart';

final serviceMangementProvider =
    ChangeNotifierProvider.autoDispose<ServiceManagementProvider>(
  (ref) => ServiceManagementProvider(),
);

class ServiceManagementProvider with ChangeNotifier {
  var weekslist = ["M", "T", "W", "T", "F", "S", "S"];
  var weekslistStatus = [false,true,false,false,false,true,false];
  Map<int, String> dropdownvalue = {
    0: "1 PM",
  };
  bool isSelected = false;
  List<Time> scheduleList = [Time(0, "1 PM", "1 PM")];

  void addToSchedule(int index) {
    scheduleList.add(Time(index, "1 PM", "1 PM"));
    notifyListeners();
  }

  void changeWeekStatus(int index,bool value) {
    weekslistStatus[index]=value;
    notifyListeners();
  }

  void clear() {
    scheduleList.clear();
    notifyListeners();
  }

  void deleteSchedule(int index) {
    scheduleList.removeWhere((element) => element.index==index,);
    notifyListeners();
  }

  void onChnaged(bool value) {
    isSelected = value;
    notifyListeners();
  }

  var items = [
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
    '6 PM',
    '7 PM',
    '8 PM',
  ];

  void onChangedDropDown(int index,String value) {
    scheduleList[index].from = value;
    notifyListeners();
  }

  void onChangedDropDownTo(int index,String value) {
    scheduleList[index].to = value;
    notifyListeners();
  }
}
