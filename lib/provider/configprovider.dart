
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';



final configProvider =ChangeNotifierProvider((ref) => Configprovider(),);

class Configprovider with ChangeNotifier{
  PersistentTabController dashboardController = PersistentTabController(initialIndex: 0);

  void setController(PersistentTabController controller){
    dashboardController=controller;
    notifyListeners();
  }
}