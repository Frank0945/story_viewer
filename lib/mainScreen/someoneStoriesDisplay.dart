import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_viewer/FullScreen/fullScreenStoriesDisplay.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/mediaWidget/imageWidget.dart';
import 'package:shimmer/shimmer.dart';

import '../dowloadStories.dart';
import '../seen.dart';

class SomeoneStoriesDisplay extends StatefulWidget {
  final int uniId;
  final int outIdx;
  SomeoneStoriesDisplay({
    Key key,
    @required this.uniId,
    @required this.outIdx,
  }) : super();
  @override
  State<StatefulWidget> createState() {
    return _SomeoneStoriesDisplay(
      uniId: uniId,
      outIdx: outIdx,
    );
  }
}

class _SomeoneStoriesDisplay extends State<SomeoneStoriesDisplay> {
  final int uniId;
  final int outIdx;
  _SomeoneStoriesDisplay({
    Key key,
    @required this.uniId,
    @required this.outIdx,
  }) : super();
  static Map blackImage = {};
  @override
  Widget build(BuildContext context) {
    MyApp.setSomeoneStoriesDisplayState[uniId.toString()] = () {
      setState(() {});
    };

    int itemCount = 0;

    print(MyApp.storyData[uniId.toString()]);

    if (MyApp.storyData != null && MyApp.storyData[uniId.toString()] != null) {
      if (MyApp.storyData[uniId.toString()]['data']['reels_media'].length !=
          0) {
        itemCount = MyApp
            .storyData[uniId.toString()]['data']['reels_media'][0]['items']
            .length;
      } else {
        return Container(
          margin: EdgeInsets.only(top: 5, left: 15, right: 15),
          height: MyApp.storyHeight,
          width: MyApp.storyHeight / 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: MyApp.themeBg3Color,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Text(
            'cannot_show_media',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ).tr(),
        );
      }
    }

    Map userData = MyApp.posterData['data']['user']['feed_reels_tray']
        ['edge_reels_tray_to_reel']['edges'][uniId];
    /*  String initialUrl =
        'https://www.instagram.com/graphql/query/?query_hash=15463e8449a83d3d60b06be7e90627c7&variables={"reel_ids":["${userData['node']['id'].toString()}"],"precomposed_overlay":false}';
*/
    String initialUrl =
        'https://www.instagram.com/graphql/query/?query_hash=30a89afdd826d78a5376008a7b81c205&variables={"reel_ids":["${userData['node']['id'].toString()}"],"tag_names":[],"location_ids":[],"highlight_reel_ids":[],"precomposed_overlay":false}';

    if (itemCount == 0) {
      if (!MyApp.dowloadUid.toString().contains(userData['node']['id']) &&
          !MyApp.jumpMode) {
        MyApp.dowloadUid.add(userData['node']['id']);
        dowloadStories(uniId, initialUrl);
      }
      return Shimmer.fromColors(
          baseColor: MyApp.themeBg3Color,
          highlightColor: MyApp.themeLoadColor,
          child: Container(
            margin: EdgeInsets.only(top: 5, left: 15, right: 15),
            height: MyApp.storyHeight,
            width: MyApp.storyHeight / 2,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ));
    } else {
      seen('display1', outIdx);
    }

    return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxHeight: MyApp.storyHeight,
        ),
        margin: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: ListView.builder(
            physics: MyApp.canScroll,
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            key: ValueKey(uniId),
            itemBuilder: (context, idx) {
              Map storyData = MyApp.storyData[uniId.toString()]['data']
                  ['reels_media'][0]['items'][itemCount - idx - 1];

              Widget isVideo = Text('');
              if (storyData['is_video'] == true) {
                isVideo = Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Icon(
                      Icons.video_library,
                      color: Colors.white,
                      size: 12,
                    ));
              }

              bool isNotBesite = true;
              if (storyData['audience'] == 'MediaAudience.BESTIES')
                isNotBesite = false;

              double width =
                  double.parse(storyData['dimensions']['width'].toString()) *
                      (MyApp.storyHeight /
                          double.parse(
                              storyData['dimensions']['height'].toString()));

              double timeAgo = DateTime.now().microsecondsSinceEpoch / 1000000 -
                  int.parse(storyData['taken_at_timestamp'].toString());

              String time;
              if (timeAgo < 60) {
                time = timeAgo.toInt().toString() + tr("second");
              }
              if (timeAgo > 60) {
                timeAgo /= 60;
                time = timeAgo.toInt().toString() + tr("minute");
              }
              if (timeAgo > 60) {
                timeAgo /= 60;
                time = timeAgo.toInt().toString() + tr("hour");
              }

              String blackImageIndex = uniId.toString() + '_' + idx.toString();

              if (blackImage[blackImageIndex] == null)
                blackImage[blackImageIndex] = 0.0;

              return Container(
                  key: ValueKey(idx),
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onPanCancel: () {
                          blackImage[blackImageIndex] = 0.0;
                          setState(() {});
                        },
                        onPanEnd: (a) {
                          blackImage[blackImageIndex] = 0.0;
                          setState(() {});
                        },
                        onPanDown: (a) {
                          blackImage[blackImageIndex] = 0.5;
                          setState(() {});
                        },
                        onTap: () {
                          MyApp.fullScreenStoryPage[uniId] = idx;
                          MyApp.fullScreenPage = outIdx;
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenStoriesDisplay()))
                              .then((data) async {
                            MyApp.setFullScreenSomeoneStoriesDisplayState =
                                null;
                            SystemChrome.setEnabledSystemUIOverlays(
                                [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                          });
                        },
                        onLongPressStart: (a) {
                          MyApp.bigImageUrl = storyData['display_url'];
                          if (storyData['is_video'] == true) {
                            int idxx = storyData['video_resources'].length - 1;
                            MyApp.bigVideoUrl =
                                storyData['video_resources'][idxx]['src'];
                            MyApp.bigVideoSize = {
                              'width': storyData['video_resources'][idxx]
                                      ['config_width']
                                  .toDouble(),
                              'height': storyData['video_resources'][idxx]
                                      ['config_height']
                                  .toDouble()
                            };
                          }

                          MyApp.bigImage();
                        },
                        onLongPressEnd: (a) {
                          MyApp.outBigImage();
                          MyApp.bigImageUrl = null;
                          MyApp.bigVideoUrl = null;
                        },
                        child: Stack(alignment: Alignment.topRight, children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            ImageWidget(
                              imageUrl: storyData['display_url'],
                              width: width,
                              height: MyApp.storyHeight,
                              loadingColor: MyApp.themeBg3Color,
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: 2, bottom: 2, right: 6, left: 6),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(150, 0, 0, 0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(children: <Widget>[
                                  Container(child: isVideo),
                                  Text(
                                    time,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ])),
                            Container(
                              width: width,
                              height: MyApp.storyHeight,
                              color: Colors.black
                                  .withOpacity(blackImage[blackImageIndex]),
                            ),
                          ]),
                          Offstage(
                              offstage: isNotBesite,
                              child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.only(
                                    top: 3, bottom: 3, right: 7, left: 7),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(141, 222, 109, 1),
                                        Color.fromRGBO(112, 192, 80, 1),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Text('close_friends',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10))
                                    .tr(),
                              ))
                        ]),
                      )));
            }));
  }
}
