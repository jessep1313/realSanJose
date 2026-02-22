import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:real_san_jose/utils/appcolor.dart';


class CustomDecoration extends ConsumerWidget {
  static var routeName = '/homescreen';

  // Accepting a list of widgets via the constructor
  final List<Widget> sections;

  const CustomDecoration({super.key, required this.sections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        actions: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: CircleAvatar(
              foregroundImage: AssetImage('assets/images/welcome1.jpg'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Hi, Amod Mandal',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
             // context.push(NotificationScreen.routeName);
            },
            child: Card(
              margin: const EdgeInsets.only(right: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.notifications,
                  color: AppColor.appThemeColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/corner_background_wave.png',
                  height: 150,
                ),
              )),
          SafeArea(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sections,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
