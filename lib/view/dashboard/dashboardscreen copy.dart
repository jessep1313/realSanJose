import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:real_san_jose/provider/configprovider.dart';
import 'package:real_san_jose/utils/appcolor.dart';
import 'package:real_san_jose/view/chat/chatscreen.dart';
import 'package:real_san_jose/view/home/homescreen.dart';
import 'package:real_san_jose/view/profile/profilescreen.dart';
import 'package:real_san_jose/view/schedule/schedule.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static String routeName = '/dashboardscreen';

  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  PersistentTabController controller = PersistentTabController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(configProvider).setController(controller);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: [
        Homescreen(),
        ScheduleScreen(),
        ChatScreen(),
        Profilescreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(
            CupertinoIcons.home,
            size: 20,
          ),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.explore_outlined,
            size: 20,
          ),
          title: ("Schedule"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.chat_bubble_outline,
            size: 20,
          ),
          title: ("Chat"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.person_2_outlined,
            size: 20,
          ),
          title: ("Profile"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.white,
        )
      ],
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,

      padding: const EdgeInsets.only(top: 8, bottom: 8),
      isVisible: true,
      decoration: NavBarDecoration(
        boxShadow: [BoxShadow(color: Colors.transparent)],
        gradient: LinearGradient(
            colors: [AppColor.appAlternateColor, AppColor.appThemeColor]),
      ),
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        // screenTransitionAnimation: ScreenTransitionAnimationSettings(
        //   // Screen transition animation on change of selected tab.
        //   animateTabTransition: true,
        //   duration: Duration(milliseconds: 200),
        //   screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        // ),
      ),
      confineToSafeArea: true,
      navBarHeight: 65, // Choose the nav bar style with this property
    );
  }
}
