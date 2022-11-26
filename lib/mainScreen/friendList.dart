import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/jumpToWhere.dart';

import '../addNiceFriendDisplay.dart';
import '../main.dart';

class FriendList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendList();
  }
}

class _FriendList extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    int itemCount = MyApp
        .posterData['data']['user']['feed_reels_tray']
            ['edge_reels_tray_to_reel']['edges']
        .length;
    return WillPopScope(
        onWillPop: () async {
          if (MyApp.stroiesDisplayController.offset ==
              MyApp.stroiesDisplayController.position.maxScrollExtent) {
            MyApp.canScroll = null;
            MyApp.bigImageBackground = null;
            MyApp.setMainStoryDisplayState();
            MyApp.setStoryDisplayState();
            MyApp.stroiesDisplayController.animateTo(0,
                duration: Duration(milliseconds: 250), curve: Curves.easeIn);
            return false;
          } else
            return true;
        },
        child: Scaffold(
          backgroundColor: MyApp.themeBgColor,
          body: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, idx) {
                double bottomM = 5;
                if (idx == itemCount - 1 &&
                    MyApp.adSizeH != 0 &&
                    !MyApp.adOffstage)
                  bottomM = 5.0 + AdmobBannerSize.BANNER.height;

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
                    margin: EdgeInsets.only(bottom: bottomM, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              jumpToWhere(idx);
                            },
                            onLongPress: () {
                              showDialog<Null>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AddNiceFriendDisplay(
                                        id: userData['node']['id'].toString(),
                                        idx: idx);
                                  }).then((val) {
                                setState(() {});
                              });
                            },
                            child: Container(
                                child: Row(
                              children: <Widget>[
                                Container(
                                  decoration: _boxDecoration,
                                  padding: EdgeInsets.all(2),
                                  margin: EdgeInsets.only(
                                      left: 13, right: 9, bottom: 8, top: 8),
                                  width: 37,
                                  height: 37,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: TransitionToImage(
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
                                Flexible(
                                    child: Text(
                                  userData['node']['user']['username'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: MyApp.themeTextColor),
                                ))
                              ],
                            ))),
                      ],
                    ));
              }),
        ));
  }
}
