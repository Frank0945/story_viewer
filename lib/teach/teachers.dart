import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/teach/storiesDisplay2Teach.dart';
import 'package:easy_localization/easy_localization.dart';

import 'fullscreenTeach.dart';

class Teachers extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: MyApp.themeBg2Color,
                ),
                margin:
                    EdgeInsets.only(top: 100, bottom: 100, right: 40, left: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      child: Text(
                        'use_teaching',
                        style: TextStyle(
                          fontSize: 20,
                          color: MyApp.themeTextColor,
                        ),
                      ).tr(),
                    ),
                    Container(
                        height: 50,
                        child: FlatButton(
                            onPressed: () {
                              showDialog<Null>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return StoriesDisplay2Teach();
                                  });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.help_outline,
                                  color: MyApp.themeTextColor,
                                ),
                                Container(width: 12),
                                Expanded(
                                  child: Text(
                                    'homepage_operation_teaching',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyApp.themeTextColor,
                                    ),
                                  ).tr(),
                                ),
                              ],
                            ))),
                    Container(
                        height: 50,
                        child: FlatButton(
                            onPressed: () {
                              showDialog<Null>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return FullscreenTeach();
                                  });
                            },
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.help_outline,
                                  color: MyApp.themeTextColor,
                                ),
                                Container(width: 12),
                                Expanded(
                                  child: Text(
                                    'full_screen_story_operation_teaching',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyApp.themeTextColor,
                                    ),
                                  ).tr(),
                                ),
                              ],
                            ))),
                  ],
                ))),
      ),
    );
  }
}
