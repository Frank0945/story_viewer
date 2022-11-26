import 'package:flutter/cupertino.dart';
import 'package:story_viewer/jumpToWhere.dart';
import 'package:story_viewer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

seen(from, int idx) async {
  bool change = false;

  if (from == 'display1') {
    double skipHeight = MyApp.storyHeight + 90;

    double screenTop = MyApp.jump['controller'].offset / skipHeight;
    double screenBottom = (MyApp.jump['controller'].offset +
            MediaQuery.of(MyApp.context).size.height -
            skipHeight) /
        skipHeight;

//    print(screenTop.toInt().toString() + "~" + screenBottom.toInt().toString());

    for (int i = screenTop.toInt(); i < screenBottom.toInt() + 1; i++) {
      int lastMedia = MyApp.order[i]['node']['latest_reel_media'];
      String userId = MyApp.order[i]['node']['id'];

      if (MyApp.storyData != null &&
          MyApp.storyData[MyApp.order[i]['uniId'].toString()] != null) {
        if (MyApp.seenMedia.indexOf("$userId:$lastMedia") == -1) {
          MyApp.seenMedia.add("$userId:$lastMedia");
          change = true;
        }
      }
    }
  } else {
    double meHeight =
        MyApp.display2Height[MyApp.order[idx]['uniId'].toString()] + 10;

    double skipHeight = rightLeft(idx) + meHeight;

    double screenTop = MyApp.jump['controller'].offset;
    double screenBottom = MyApp.jump['controller'].offset +
        MediaQuery.of(MyApp.context).size.height;

    if (skipHeight >= screenTop && skipHeight <= screenBottom) {
      int lastMedia = MyApp.order[idx]['node']['latest_reel_media'];
      String userId = MyApp.order[idx]['node']['id'];

      if (MyApp.seenMedia.indexOf("$userId:$lastMedia") == -1) {
        MyApp.seenMedia.add("$userId:$lastMedia");
        change = true;
      }
    }
  }

  if (change) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('seen' + MyApp.cookie[0], MyApp.seenMedia);
  }
}
