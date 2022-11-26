import 'package:flutter/services.dart';
import 'package:story_viewer/FullScreen/fullScreenSomeoneStoriesDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/launchURL.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/teach/fullscreenTeach.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullScreenStoriesDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    MyApp.canSetHeight = false;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return _FullScreenStoriesDisplay();
  }
}

class _FullScreenStoriesDisplay extends State<FullScreenStoriesDisplay> {
  IconData zoomIcon = Icons.fullscreen;
  Widget _animate = Opacity(opacity: 0);
  PageController outController;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    MyApp.setFullScreenStoriesDisplayState = () {
      setState(() {
        _animate = Container(
          color: Colors.black.withOpacity(0.5),
        );
      });
    };
    if (first) {
      first = false;
      Future.delayed(Duration(seconds: 1), () {
        if (MyApp.firstUseFullScreen == null) {
          saveState() async {
            MyApp.firstUseFullScreen = false;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('firstUseFullScreen', false);
          }
          saveState();
          showDialog<Null>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return FullscreenTeach();
              });
        }
      });
    }

    int itemCount = MyApp
        .posterData['data']['user']['feed_reels_tray']
            ['edge_reels_tray_to_reel']['edges']
        .length;

    return Stack(children: <Widget>[
      SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 3,
            controller: outController = PageController(initialPage: 1),
            onPageChanged: (page) {
              if (page == 0) Navigator.pop(context);
              if (page == 2) {
                outController.jumpToPage(1);
                launchURL(MyApp.storyUrl);
              }
            },
            itemBuilder: (context, index) {
              if (index == 0)
                return Container(
                  color: Colors.white,
                );

              if (index == 2) return Container();

              return PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount + 2,
                  controller: MyApp.fullScreenPageController = PageController(
                      initialPage: MyApp.fullScreenPage),
                  onPageChanged: (idx) {
                    if (idx == itemCount)
                      Navigator.pop(context);
                    else
                      MyApp.fullScreenPage = idx;
                    if (MyApp.fullScreenIsAnimtae)
                      Future.delayed(Duration(milliseconds: 300), () {
                        MyApp.fullScreenIsAnimtae = false;
                        MyApp.setFullScreenStoriesDisplayState();
                      });
                  },
                  itemBuilder: (context, idx) {
                    if (idx == itemCount)
                      return Container();
                    else {
                      return FullScreenSomeoneStoriesDisplay(
                          uniId: MyApp.order[idx]['uniId'],
                          outIdx: idx,
                          maxPage: itemCount,
                          pageController: MyApp.fullScreenPageController);
                    }
                  });
            }),
      )),
      Offstage(
          offstage: !MyApp.fullScreenIsAnimtae,
          child: AnimatedSwitcher(
            child: _animate,
            duration: Duration(milliseconds: 1000),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              child: child,
              opacity: animation,
            ),
          ))
    ]);
  }
}
