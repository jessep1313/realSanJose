import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = ChangeNotifierProvider<OnBoardingProvider>(
  (ref) => OnBoardingProvider(),
);

class OnBoardingProvider with ChangeNotifier {
  int currentIndex = 0;
  final List<Map<String, String>> pages = [
    {
      'title': 'Your Health, Our Priority',
      'description':
          'Users perceive the app as a trustworthy source of professional medical advice',
      'image': 'assets/images/landing1.png'
    },
    {
      'title': "Expert Care at Your Fingertips",
      'description':
          "Just a Tap Away emphasizes the minimal effort required to improve health, making the app seem user-friendly.",
      'image': 'assets/images/landing2.png'
    },
    {
      'title': "Connecting You to Better Health",
      'description':
          "The promise of a healthier self can drive users to explore app features more deeply.",
      'image': 'assets/images/landing3.png'
    },
  ];

  void onChagedIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
