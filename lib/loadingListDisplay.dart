import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:shimmer/shimmer.dart';

class LoadingListDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoadingListDisplay();
  }
}

class _LoadingListDisplay extends State<LoadingListDisplay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyApp.themeBgColor,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                  child: Shimmer.fromColors(
                      period: Duration(seconds: 2),
                      baseColor: Colors.grey.withOpacity(0.3),
                      highlightColor: MyApp.themeTextColor.withOpacity(0.5),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 100,
                        height: 100,
                      )))
            ],
          )),
    );
  }
}
