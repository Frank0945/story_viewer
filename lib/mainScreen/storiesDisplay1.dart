import 'package:admob_flutter/admob_flutter.dart';

import '../addNiceFriendDisplay.dart';
import '../dowloadStories.dart';
import 'someoneStoriesDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:story_viewer/launchURL.dart';

class StoriesDisplay1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoriesDisplay1();
  }
}

class _StoriesDisplay1 extends State<StoriesDisplay1> {
  int key = 0;
  double _initialScrollOffset = 0;
  @override
  Widget build(BuildContext context) {
    MyApp.setRankStoryDisplayState = () {
      key += 1;
      setState(() {});
      if (MyApp.jump['controller'] != null)
        _initialScrollOffset = MyApp.jump['controller'].offset;
    };
    MyApp.setStoryDisplayState = () {
      setState(() {});
    };
    int itemCount = MyApp
        .posterData['data']['user']['feed_reels_tray']
            ['edge_reels_tray_to_reel']['edges']
        .length;

    return Scaffold(
        backgroundColor: MyApp.themeBgColor,
        body: RefreshIndicator(
            backgroundColor: MyApp.themeBg2Color,
            onRefresh: _onRefresh,
            child: ListView.builder(
                key: ValueKey(key),
                physics: MyApp.canScroll,
                controller: MyApp.jump['controller'] =
                    ScrollController(initialScrollOffset: _initialScrollOffset),
                itemCount: itemCount,
                shrinkWrap: true,
                itemBuilder: (context, idx) {
                  double bottomM = 10;
                  if (idx == itemCount - 1 &&
                      MyApp.adSizeH != 0 &&
                      !MyApp.adOffstage)
                    bottomM = 10.0 + AdmobBannerSize.BANNER.height;

                  Map userData = MyApp.order[idx];

                  Decoration _boxDecoration = BoxDecoration();

                  if (MyApp.priority.indexOf(userData['node']['id']) != -1) {
                    _boxDecoration = BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    );
                  }
                  return Container(
                      key: ValueKey(idx),
                      margin: EdgeInsets.only(bottom: bottomM, top: 10),
                      child: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                launchURL('https://www.instagram.com/' +
                                    userData['node']['user']['username']
                                        .toString());
                              },
                              onLongPress: () {
                                showDialog<Null>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AddNiceFriendDisplay(
                                          id: userData['node']['id'].toString(),
                                          idx: idx);
                                    });
                              },
                              child: Container(
                                  child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: _boxDecoration,
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        bottom: 10,
                                        top: 10),
                                    width: 45,
                                    height: 45,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: TransitionToImage(
                                        fit: BoxFit.cover,
                                        image: AdvancedNetworkImage(
                                          userData['node']['user']
                                              ['profile_pic_url'],
                                          useDiskCache: true,
                                          cacheRule: CacheRule(
                                              maxAge: Duration(days: 1)),
                                        ),
                                        loadingWidget: Container(
                                          color: MyApp.themeBg3Color,
                                        ),
                                        placeholder: Container(
                                          color: MyApp.themeBg3Color,
                                        ),
                                        enableRefresh: true,
                                      ),
                                    ),
                                  ),
                                  Text(userData['node']['user']['username'],
                                      style: TextStyle(
                                        color: MyApp.themeTextColor,
                                      ))
                                ],
                              ))),
                          SomeoneStoriesDisplay(
                              uniId: userData['uniId'], outIdx: idx)
                        ],
                      )));
                })));
  }

  Future<Null> _onRefresh() async {
    MyApp.refresh = true;
    dowloadStories(null, MyApp.postersDataUrl);
    await Future.delayed(Duration(seconds: 25), () {
      return null;
    });
  }
}
