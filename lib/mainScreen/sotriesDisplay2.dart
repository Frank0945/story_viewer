import 'package:admob_flutter/admob_flutter.dart';
import 'package:story_viewer/dowloadStories.dart';
import 'package:story_viewer/mainScreen/someoneStoriesDisplay2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StoriesDisplay2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoriesDisplay2();
  }
}

class _StoriesDisplay2 extends State<StoriesDisplay2> {
  static int key = 0;
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
      body: Container(
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              backgroundColor: MyApp.themeBg2Color,
              child: StaggeredGridView.countBuilder(
                  key: ValueKey(key),
                  padding: EdgeInsets.only(right: 10, left: 10),
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  physics: MyApp.canScroll,
                  controller: MyApp.jump['controller'] = ScrollController(
                      initialScrollOffset: _initialScrollOffset),
                  itemCount: itemCount,
                  itemBuilder: (context, idx) {
                    double bottomM = 0;
                    if (idx == itemCount - 1 &&
                        MyApp.adSizeH != 0 &&
                        !MyApp.adOffstage)
                      bottomM = 0.0 + AdmobBannerSize.BANNER.height;

                    if (MyApp.storyBordier == null ||
                        MyApp.storyBordier[idx.toString()] == null) {
                      MyApp.storyBordier[idx.toString()] = {};
                      MyApp.storyBordier[idx.toString()]['color'] =
                          Colors.transparent;
                      MyApp.storyBordier[idx.toString()]['width'] = 0.0;
                    }

                    double topM = 0;
                    if (idx == 0) topM = 10;
                    if (idx == 1) topM = 67;

                    return Padding(
                        key: ValueKey(idx),
                        padding: EdgeInsets.only(top: topM, bottom: bottomM),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 5,
                                spreadRadius: 0,
                                offset: Offset(
                                  -3.0,
                                  0.0,
                                ),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SomeoneStoriesDisplay2(
                              uniId: MyApp.order[idx]['uniId'], outIdx: idx),
                        ));
                  }))),
    );
  }

  Future<Null> _onRefresh() async {
    MyApp.refresh = true;
    dowloadStories(null, MyApp.postersDataUrl);
    await Future.delayed(Duration(seconds: 25), () {
      return null;
    });
  }
}
