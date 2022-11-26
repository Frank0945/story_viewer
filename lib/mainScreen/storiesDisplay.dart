import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/mainScreen/sotriesDisplay2.dart';
import 'package:story_viewer/mainScreen/storiesDisplay1.dart';
import 'package:story_viewer/mediaWidget/imageWidget.dart';
import 'package:story_viewer/mediaWidget/videoWidget.dart';
import 'package:story_viewer/settingDialog/dowloadUserData.dart';
import 'package:story_viewer/settingDialog/loadingDialog.dart';
import 'package:story_viewer/settingDialog/setting.dart';
import 'package:story_viewer/showGiveStarDialog.dart';
import 'package:story_viewer/teach/storiesDisplay2Teach.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../showAskDialog.dart';
import 'friendList.dart';

class StoriesDisplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoriesDisplay();
  }
}

class _StoriesDisplay extends State<StoriesDisplay> {
  static Widget _bigImage;
  static Function missBackground;
  static Function seeBackground;
  static bool first = true;
  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      Future.delayed(Duration(seconds: 1), () {
        if (MyApp.loginDays == 45) showAskDialog();
        if (MyApp.firstUseMain == null)
          showDialog<Null>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return StoriesDisplay2Teach();
              });

        if (MyApp.giveStarWindow == true) showGiveStarDialog();
      });
    }
    MyApp.setMainStoryDisplayState = () {
      setState(() {});
    };
    missBackground = () {
      MyApp.canScroll = NeverScrollableScrollPhysics();
      MyApp.bigImageBackground = Container(
        color: Colors.white.withOpacity(0.1),
      );
    };
    seeBackground = () {
      MyApp.canScroll = null;
      MyApp.bigImageBackground = null;
    };
    MyApp.bigImage = () {
      setState(() {
        missBackground();
        _bigImage = Container(
          child: ImageWidget(
            imageUrl: MyApp.bigImageUrl,
            height: double.infinity,
            width: double.infinity,
            loadingColor: MyApp.themeBg3Color,
          ),
        );
        if (MyApp.bigVideoUrl != null) {
          _bigImage = Container(
            key: ValueKey(0),
            child: VideoWidget(
              videoUrl: MyApp.bigVideoUrl,
              height: MyApp.bigVideoSize['height'],
              width: MyApp.bigVideoSize['width'],
              loadingColor: MyApp.themeBg3Color,
            ),
          );
        }
      });
    };
    MyApp.outBigImage = () {
      MyApp.canScroll = null;
      MyApp.setStoryDisplayState();
      setState(() {
        seeBackground();
        _bigImage = null;
      });
    };

    double adSizeH = MyApp.adSizeH;
    if (MyApp.adOffstage) adSizeH = 0;

    return SafeArea(
        key: ValueKey(0),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: MyApp.stroiesDisplayController = ScrollController(),
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, idx) {
              if (idx == 1)
                return Container(
                  width: MediaQuery.of(context).size.width - 120,
                  child: FriendList(),
                );
              return Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                      Stack(alignment: Alignment.topRight, children: <Widget>[
                    SizedBox(
                      child: MyApp.displayStory,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      elevation: 3,
                      margin: EdgeInsets.only(top: 10, right: 15),
                      color: MyApp.themeBg2Color,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        right: 5,
                                        left: 5,
                                      ),
                                      child: Icon(
                                        Icons.settings,
                                        size: 22,
                                        color: MyApp.themeTextColor,
                                      )),
                                  onTap: () {
                                    showDialog<Null>(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return Setting();
                                        });
                                  },
                                  onLongPress: () {
                                    showDialog<Null>(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return LoadingDialog();
                                        });
                                    dowloadUserData();
                                  },
                                ),
                                InkWell(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        right: 5,
                                        left: 5,
                                      ),
                                      child: Icon(
                                        MyApp.displayIcon,
                                        size: 22,
                                        color: MyApp.themeTextColor,
                                      )),
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    int dis = prefs.getInt("display");
                                    if (dis == 1) {
                                      _saveDisplayMod(2);
                                      MyApp.displayStory = StoriesDisplay2();
                                      MyApp.displayIcon =
                                          Icons.format_list_bulleted;
                                    } else {
                                      _saveDisplayMod(1);
                                      MyApp.displayStory = StoriesDisplay1();
                                      MyApp.displayIcon = Icons.widgets;
                                    }
                                    setState(() {});
                                  },
                                ),
                                InkWell(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                        right: 5,
                                        left: 5,
                                      ),
                                      child: Icon(
                                        Icons.people,
                                        size: 22,
                                        color: MyApp.themeTextColor,
                                      )),
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    int dis = prefs.getInt("display");

                                    int whichPage = 2;
                                    if (dis == 1) whichPage = 1;
                                    MyApp.jump['whichPage'] = whichPage;

                                    setState(() {
                                      missBackground();
                                    });
                                    MyApp.stroiesDisplayController.animateTo(
                                        MyApp.stroiesDisplayController.position
                                            .maxScrollExtent,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeIn);
                                  },
                                ),
                              ])),
                    ),
                    GestureDetector(
                        onTap: () {
                          if (MyApp.stroiesDisplayController.offset != 0) {
                            setState(() {
                              seeBackground();
                            });
                            MyApp.setStoryDisplayState();
                            MyApp.stroiesDisplayController.animateTo(0,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeIn);
                          }
                        },
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                            child: MyApp.bigImageBackground)),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.only(bottom: adSizeH),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 170),
                          child: _bigImage,
                          transitionBuilder:
                              (Widget child, Animation<double> animation) =>
                                  ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              child: child,
                              opacity: animation,
                            ),
                          ),
                        )),
                  ]));
            }));
  }

  _saveDisplayMod(int which) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("display", which);
  }
}
