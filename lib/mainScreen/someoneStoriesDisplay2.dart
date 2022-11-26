import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:story_viewer/FullScreen/fullScreenStoriesDisplay.dart';
import 'package:story_viewer/dowloadStories.dart';
import 'package:story_viewer/mediaWidget/imageWidget.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/storyLineProgress.dart';
import 'package:shimmer/shimmer.dart';

import '../addNiceFriendDisplay.dart';
import '../launchURL.dart';
import '../seen.dart';

class SomeoneStoriesDisplay2 extends StatefulWidget {
  final int uniId;
  final int outIdx;
  SomeoneStoriesDisplay2({
    @required this.uniId,
    @required this.outIdx,
  }) : super();
  @override
  State<StatefulWidget> createState() {
    return _SomeoneStoriesDisplay2(
      uniId: uniId,
      outIdx: outIdx,
    );
  }
}

class _SomeoneStoriesDisplay2 extends State<SomeoneStoriesDisplay2> {
  final int uniId;
  final int outIdx;
  _SomeoneStoriesDisplay2({
    @required this.uniId,
    @required this.outIdx,
  }) : super();
  static Map blackImage = {};
  static double height = 0;
  @override
  Widget build(BuildContext context) {
    MyApp.setSomeoneStoriesDisplayState[uniId.toString()] = () {
      setState(() {});
    };
    Map userData = MyApp.posterData['data']['user']['feed_reels_tray']
        ['edge_reels_tray_to_reel']['edges'][uniId];

    int itemCount = 0;

    if (MyApp.storyData != null && MyApp.storyData[uniId.toString()] != null) {
      if (MyApp.storyData[uniId.toString()]['data']['reels_media'].length !=
          0) {
        itemCount = MyApp
            .storyData[uniId.toString()]['data']['reels_media'][0]['items']
            .length;
      } else {
        MyApp.display2Height[uniId.toString()] = 50;
        return Container(
            key: ValueKey(uniId),
            decoration: BoxDecoration(
                color: MyApp.themeBg3Color,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 50,
            child: FlatButton(
                onPressed: () {
                  launchURL('https://www.instagram.com/' +
                      userData['node']['user']['username'].toString());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: TransitionToImage(
                            width: 30,
                            fit: BoxFit.cover,
                            image: AdvancedNetworkImage(
                              userData['node']['user']['profile_pic_url'],
                              useDiskCache: true,
                              cacheRule: CacheRule(maxAge: Duration(days: 1)),
                            ),
                            loadingWidget: Container(
                              color: MyApp.themeBg3Color,
                            ),
                            placeholder: Container(
                              color: MyApp.themeBg3Color,
                            ),
                            enableRefresh: true,
                          ),
                        )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                            child: Text(
                          userData['node']['user']['username'],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: MyApp.themeTextColor),
                        )),
                        SizedBox(height: 2),
                        Text(
                          'cannot_show_media',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ).tr()
                      ],
                    )),
                  ],
                )));
      }
    }

    Decoration _boxDecoration = BoxDecoration();

    String userId = userData['node']['id'];

    if (MyApp.priority.indexOf(userId) != -1) {
      _boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      );
    }

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

      return Container(
          key: ValueKey(uniId),
          decoration: BoxDecoration(
            border: Border.all(
                color: MyApp.storyBordier[outIdx.toString()]['color'],
                width: MyApp.storyBordier[outIdx.toString()]['width']),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(children: <Widget>[
            Shimmer.fromColors(
                baseColor: MyApp.themeBg3Color,
                highlightColor: MyApp.themeLoadColor,
                child: Container(
                  height: MyApp.storiesDisplay2Height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                )),
            Container(
                height: 60,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black38,
                          Colors.transparent,
                        ],
                        begin: FractionalOffset(0, 0),
                        end: FractionalOffset(0, 1)),
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            Container(
                child: InkWell(
                    onTap: () {
                      launchURL('https://www.instagram.com/' +
                          userData['node']['user']['username'].toString());
                    },
                    child: SizedBox(
                        child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: _boxDecoration,
                          margin: EdgeInsets.only(
                              left: 8, right: 7, bottom: 12, top: 12),
                          width: 30,
                          height: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: TransitionToImage(
                              fit: BoxFit.cover,
                              image: AdvancedNetworkImage(
                                userData['node']['user']['profile_pic_url'],
                                useDiskCache: true,
                                cacheRule: CacheRule(maxAge: Duration(days: 1)),
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
                            child: Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Text(
                                  userData['node']['user']['username'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          offset: Offset(1, 1),
                                          blurRadius: 5)
                                    ],
                                  ),
                                )))
                      ],
                    )))),
          ]));
    } else if (itemCount != -1) {
      int storyDataLength = MyApp
              .storyData[uniId.toString()]['data']['reels_media'][0]['items']
              .length -
          1;

      Map storyData = MyApp.storyData[uniId.toString()]['data']['reels_media']
          [0]['items'][storyDataLength];

      height = double.parse(storyData['dimensions']['height'].toString()) *
          ((MediaQuery.of(context).size.width / 2 - 20) /
              double.parse(storyData['dimensions']['width'].toString()));
      MyApp.display2Height[uniId.toString()] = height;
      seen('display2', outIdx);
    }

    return Container(
        key: ValueKey(uniId),
        height: height,
        alignment: Alignment.center,
        child: PageView.builder(
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

              int maxStory = MyApp
                  .storyData[uniId.toString()]['data']['reels_media'][0]
                      ['items']
                  .length;

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
                time = timeAgo.toInt().toString() + tr('hour');
              }

              String blackImageIndex = uniId.toString() + '_' + idx.toString();

              if (blackImage[blackImageIndex] == null)
                blackImage[blackImageIndex] = 0.0;

              bool isNotBesite = true;
              if (storyData['audience'] == 'MediaAudience.BESTIES')
                isNotBesite = false;

              return Container(
                  key: ValueKey(idx),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: MyApp.storyBordier[outIdx.toString()]['color'],
                        width: MyApp.storyBordier[outIdx.toString()]['width']),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
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
                              SystemChrome.setEnabledSystemUIOverlays([
                                SystemUiOverlay.top,
                                SystemUiOverlay.bottom
                              ]);
                            });
                          },
                          onLongPressStart: (a) {
                            MyApp.bigImageUrl = storyData['display_url'];
                            if (storyData['is_video'] == true) {
                              int idxx =
                                  storyData['video_resources'].length - 1;
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
                          child: Stack(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      ImageWidget(
                                        height: double.infinity,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                        imageUrl: storyData['display_url'],
                                        loadingColor: MyApp.themeBg3Color,
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              top: 2,
                                              bottom: 2,
                                              right: 6,
                                              left: 6),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(150, 0, 0, 0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(child: isVideo),
                                                Text(
                                                  time,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ])),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                                blackImage[blackImageIndex]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                20,
                                      ),
                                    ],
                                  ),
                                  Offstage(
                                      offstage: isNotBesite,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 3,
                                            bottom: 3,
                                            right: 7,
                                            left: 7),
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: <Color>[
                                                Color.fromRGBO(
                                                    141, 222, 109, 1),
                                                Color.fromRGBO(112, 192, 80, 1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Text('close_friends',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10))
                                            .tr(),
                                      )),
                                ],
                              ),
                              Container(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent,
                                          ],
                                          begin: FractionalOffset(0, 0),
                                          end: FractionalOffset(0, 1)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      20,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
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
                                              id: userData['node']['id']
                                                  .toString(),
                                              idx: outIdx,
                                            );
                                          });
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: _boxDecoration,
                                          margin: EdgeInsets.only(
                                              left: 8,
                                              right: 7,
                                              bottom: 12,
                                              top: 12),
                                          width: 30,
                                          height: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(1000),
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
                                                color: Colors.grey[300],
                                              ),
                                              placeholder: Container(
                                                color: Colors.grey[300],
                                              ),
                                              enableRefresh: true,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 6),
                                                child: Text(
                                                  userData['node']['user']
                                                      ['username'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.black38,
                                                          offset: Offset(1, 1),
                                                          blurRadius: 5)
                                                    ],
                                                  ),
                                                ))),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 4, right: 17, left: 12),
                                  child: StoryLineProgress(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    valueColor: Colors.white,
                                    value: idx,
                                    maxValue: maxStory,
                                    height: 2,
                                    padding: 1,
                                  )),
                            ],
                          ))));
            }));
  }
}
