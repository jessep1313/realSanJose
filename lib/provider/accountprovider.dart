import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountProvider = ChangeNotifierProvider(
  (ref) => Accountprovider(),
);

class Accountprovider with ChangeNotifier {
  int selectedOption = 1;
  bool isSelected = false;

  void onChnaged(int value) {
    selectedOption = value;
    notifyListeners();
  }

  void onChnagedCheckBox(bool value) {
    isSelected = value;
    notifyListeners();
  }
}
