import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';

jumpToWhere(int where) {
  double skipHeight = 0;

  if (MyApp.jump['whichPage'] == 1) {
    skipHeight = (90 + MyApp.storyHeight) * (where);
  } else {
    skipHeight = rightLeft(where);
  }

  MyApp.jumpMode = true;

  MyApp.storyBordier[where.toString()] = {};
  MyApp.storyBordier[where.toString()]['color'] = Colors.blueAccent;
  MyApp.storyBordier[where.toString()]['width'] = 4.0;

  if (skipHeight == 0) skipHeight = 1;
  MyApp.jump['controller'].jumpTo(skipHeight);
  MyApp.setStoryDisplayState();

  Future.delayed(Duration(seconds: 1), () {
    MyApp.storyBordier[where.toString()]['color'] = Colors.transparent;
    MyApp.storyBordier[where.toString()]['width'] = 0.0;
    MyApp.jumpMode = false;
    MyApp.setStoryDisplayState();
  });
  MyApp.stroiesDisplayController.animateTo(0,
      duration: Duration(milliseconds: 250), curve: Curves.easeIn);
  MyApp.outBigImage();
}

rightLeft(where) {
  double rightStoryHeight = 0;
  double leftStoryHeight = 0;

  if (where == 0) return 1.0;

  for (int i = 0; i < where; i++) {
    String idx = MyApp.order[i]['uniId'].toString();

    if (MyApp.display2Height[idx] == null)
      MyApp.display2Height[idx] = MyApp.storiesDisplay2Height;

    double skip = 10.0;
    double height = MyApp.display2Height[idx] + skip;

    if (leftStoryHeight + 10 < rightStoryHeight + 67) {
      leftStoryHeight += height;
    } else {
      rightStoryHeight += height;
    }

    if (i == where - 1) {
      if (rightStoryHeight + 67 > leftStoryHeight + 10)
        return leftStoryHeight;
      else
        return rightStoryHeight;
    }
  }
}
