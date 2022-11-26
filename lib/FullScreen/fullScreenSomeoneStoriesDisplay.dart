import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:story_viewer/mediaWidget/imageWidget.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/mediaWidget/videoWidget.dart';
import 'package:shimmer/shimmer.dart';

import '../dowloadStories.dart';
import '../launchURL.dart';
import '../storyLineProgress.dart';

class FullScreenSomeoneStoriesDisplay extends StatefulWidget {
  final int uniId;
  final int outIdx;
  final int maxPage;
  final pageController;
  FullScreenSomeoneStoriesDisplay({
    Key key,
    @required this.uniId,
    @required this.outIdx,
    @required this.maxPage,
    @required this.pageController,
  }) : super();
  @override
  State<StatefulWidget> createState() {
    return _FullScreenSomeoneStoriesDisplay(
        uniId: uniId,
        maxPage: maxPage,
        pageController: pageController,
        outIdx: outIdx);
  }
}

class _FullScreenSomeoneStoriesDisplay
    extends State<FullScreenSomeoneStoriesDisplay> {
  final int uniId;
  final int maxPage;
  final int outIdx;
  final pageController;
  _FullScreenSomeoneStoriesDisplay({
    Key key,
    @required this.uniId,
    @required this.outIdx,
    @required this.maxPage,
    @required this.pageController,
  }) : super();
  static int maxStory = 0;
  Map storyController = {};
  double tapTime;
  @override
  Widget build(BuildContext context) {
    MyApp.setFullScreenSomeoneStoriesDisplayState = () {
      setState(() {});
    };
    int itemCount = 0;
    if (MyApp.storyData != null && MyApp.storyData[uniId.toString()] != null)
      itemCount = MyApp
          .storyData[uniId.toString()]['data']['reels_media'][0]['items']
          .length;

    Map userData = MyApp.posterData['data']['user']['feed_reels_tray']
        ['edge_reels_tray_to_reel']['edges'][uniId];

    /*  String initialUrl =
        'https://www.instagram.com/graphql/query/?query_hash=15463e8449a83d3d60b06be7e90627c7&variables={"reel_ids":["${userData['node']['id'].toString()}"],"precomposed_overlay":false}';
*/
    String initialUrl =
        'https://www.instagram.com/graphql/query/?query_hash=30a89afdd826d78a5376008a7b81c205&variables={"reel_ids":["${userData['node']['id'].toString()}"],"tag_names":[],"location_ids":[],"highlight_reel_ids":[],"precomposed_overlay":false}';

    if (itemCount == 0) {
      if (!MyApp.dowloadUid.toString().contains(userData['node']['id'])) {
        MyApp.dowloadUid.add(userData['node']['id']);
        dowloadStories(uniId, initialUrl);
      }
      return Stack(children: [
        Shimmer.fromColors(
            baseColor: Colors.grey[900],
            highlightColor: Colors.grey[800],
            child: Container(
              color: Colors.grey,
            )),
        Stack(alignment: Alignment.topLeft, children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black87,
              Colors.transparent,
            ], begin: FractionalOffset(0, 0), end: FractionalOffset(0, 1))),
          ),
          Row(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 10),
                width: 35,
                height: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: TransitionToImage(
                    image: AdvancedNetworkImage(
                      userData['node']['user']['profile_pic_url'],
                      useDiskCache: true,
                      cacheRule: CacheRule(maxAge: Duration(days: 1)),
                    ),
                    loadingWidget: Container(
                      color: Colors.grey[700],
                    ),
                    placeholder: Container(
                      child: Icon(Icons.error_outline),
                      color: Colors.grey[700],
                    ),
                    enableRefresh: true,
                  ),
                ),
              ),
              Text(
                userData['node']['user']['username'],
                style: TextStyle(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(1, 1),
                        blurRadius: 5)
                  ],
                ),
              ),
            ],
          )
        ])
      ]);
    }
    if (MyApp.fullScreenStoryPage == null ||
        MyApp.fullScreenStoryPage[uniId] == null)
      MyApp.fullScreenStoryPage[uniId] = 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          controller: storyController[uniId.toString()] = PageController(
              keepPage: true, initialPage: MyApp.fullScreenStoryPage[uniId]),
          onPageChanged: (idx) {
            MyApp.fullScreenStoryPage[uniId] = idx;
          },
          itemBuilder: (context, idx) {
            Map storyData = MyApp.storyData[uniId.toString()]['data']
                ['reels_media'][0]['items'][itemCount - idx - 1];

            MyApp.storyUrl =
                "https://www.instagram.com/stories/${userData['node']['user']['username']}/${storyData['id']}/";

            maxStory = MyApp
                .storyData[uniId.toString()]['data']['reels_media'][0]['items']
                .length;

            double height = double.parse(
                    storyData['dimensions']['height'].toString()) *
                (MediaQuery.of(context).size.width /
                    double.parse(storyData['dimensions']['width'].toString()));

            Widget display = ImageWidget(
              imageUrl: storyData['display_url'],
              loadingColor: Colors.grey[700],
              height: height,
              width: double.infinity,
            );
            if (storyData['is_video'] == true) {
              int idxx = storyData['video_resources'].length - 1;

              MyApp.bigImageUrl = storyData['display_url'];
              display = VideoWidget(
                videoUrl: storyData['video_resources'][idxx]['src'],
                loadingColor: Colors.grey[700],
                height: storyData['video_resources'][idxx]['config_height']
                    .toDouble(),
                width: storyData['video_resources'][idxx]['config_width']
                    .toDouble(),
              );
            }

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

            void nextPage() {
              double now = DateTime.now().microsecondsSinceEpoch / 1000000;

              if (now - tapTime < 0.2) {
                if (!MyApp.fullScreenIsAnimtae) if (MyApp.fullScreenPage !=
                    maxPage) {
                  if (MyApp.fullScreenStoryPage[uniId] != maxStory - 1) {
                    storyController[uniId.toString()].nextPage(
                        duration: Duration(milliseconds: 1),
                        curve: Curves.easeIn);
                  } else {
                    _notTouch('next', pageController);
                  }
                }
              } else if (storyData['is_video'] == true) {
                MyApp.playVideo();
              }
            }

            void previousPage() {
              double now = DateTime.now().microsecondsSinceEpoch / 1000000;

              if (now - tapTime < 0.2) {
                if (!MyApp.fullScreenIsAnimtae) {
                  if (MyApp.fullScreenStoryPage[uniId] != 0) {
                    storyController[uniId.toString()].previousPage(
                        duration: Duration(milliseconds: 1),
                        curve: Curves.easeIn);
                  } else if (MyApp.fullScreenPage != 0) {
                    MyApp.fullScreenStoryPage[
                        MyApp.order[outIdx - 1]['uniId'] -
                            1] = MyApp
                        .storyData[MyApp.order[outIdx - 1]['uniId'].toString()]
                            ['data']['reels_media'][0]['items']
                        .length;
                    _notTouch('previous', pageController);
                  }
                  if (MyApp.fullScreenPage == 0 &&
                      MyApp.fullScreenStoryPage[uniId] == 0) {
                    storyController[uniId.toString()].previousPage(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                    if (storyData['is_video'] == true) MyApp.playVideo();
                  }
                }
              } else if (storyData['is_video'] == true) {
                MyApp.playVideo();
              }
            }

            bool isNotBesite = true;
            if (storyData['audience'] == 'MediaAudience.BESTIES')
              isNotBesite = false;

            return Container(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Stack(alignment: Alignment.bottomRight, children: [
                      Stack(alignment: Alignment.topCenter, children: [
                        display,
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Colors.black38,
                                Colors.transparent,
                              ],
                                  begin: FractionalOffset(0, 0),
                                  end: FractionalOffset(0, 1))),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: GestureDetector(
                              onTapDown: (a) {
                                tapTime =
                                    DateTime.now().microsecondsSinceEpoch /
                                        1000000;
                                if (storyData['is_video'] == true)
                                  MyApp.pauseVideo();
                              },
                              onTapCancel: () {
                                previousPage();
                              },
                              onTapUp: (a) {
                                previousPage();
                              },
                              child: Container(
                                height: height,
                                color: Colors.transparent,
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTapDown: (a) {
                                tapTime =
                                    DateTime.now().microsecondsSinceEpoch /
                                        1000000;
                                if (storyData['is_video'] == true)
                                  MyApp.pauseVideo();
                              },
                              onTapCancel: () {
                                nextPage();
                              },
                              onTapUp: (a) {
                                nextPage();
                              },
                              child: Container(
                                height: height,
                                color: Colors.transparent,
                              ),
                            ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, left: 10),
                          child: StoryLineProgress(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: Colors.white,
                            value: idx,
                            maxValue: maxStory,
                            height: 2,
                            padding: 1.5,
                          ),
                        ),
                        Row(children: <Widget>[
                          InkWell(
                              onTap: () {
                                launchURL('https://www.instagram.com/' +
                                    userData['node']['user']['username']
                                        .toString());
                              },
                              child: Container(
                                  child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        bottom: 12,
                                        top: 12),
                                    width: 35,
                                    height: 35,
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
                                          color: Colors.grey[700],
                                        ),
                                        placeholder: Container(
                                          child: Icon(Icons.error_outline),
                                          color: Colors.grey[700],
                                        ),
                                        enableRefresh: true,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    userData['node']['user']['username'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      shadows: [
                                        BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(1, 1),
                                            blurRadius: 5)
                                      ],
                                    ),
                                  ),
                                  Container(width: 10, height: 1),
                                  Text(time,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black38,
                                              offset: Offset(1, 1),
                                              blurRadius: 5)
                                        ],
                                      )),
                                ],
                              ))),
                        ]),
                      ]),
                      Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 0,
                            ),
                          ]),
                          margin: EdgeInsets.all(12),
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            icon: Icon(Icons.open_in_new),
                            onPressed: () {
                              launchURL(MyApp.storyUrl);
                            },
                          ))
                    ]),
                    Offstage(
                        offstage: isNotBesite,
                        child: Container(
                          margin: EdgeInsets.only(right: 15, top: 20),
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, right: 10, left: 10),
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
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                              .tr(),
                        ))
                  ],
                ));
          }),
    );
  }

  void _notTouch(action, controller) {
    MyApp.fullScreenIsAnimtae = true;
    MyApp.setFullScreenStoriesDisplayState();
    if (action == 'next') {
      MyApp.fullScreenPageController.nextPage(
          curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    } else {
      MyApp.fullScreenPageController.previousPage(
          curve: Curves.easeIn, duration: Duration(milliseconds: 200));
    }
  }
}
