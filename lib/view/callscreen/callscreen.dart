import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerWidget {
  static var routeName = "/callscreen";

  const CallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/images/specialist.jpg",
                fit: BoxFit.fitHeight),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black45,
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Card(
              elevation: 0,
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black87,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(Icons.video_call)),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(Icons.mic)),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: SizedBox(
                    height: 110,
                    width: 110,
                    child: Image.asset("assets/images/specialist.jpg",
                        fit: BoxFit.fitHeight),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Neil Owler",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  "00:05:20",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
