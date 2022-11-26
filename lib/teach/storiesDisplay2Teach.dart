import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';

class StoriesDisplay2Teach extends Dialog {
  @override
  Widget build(BuildContext context) {
    saveState() async {
      MyApp.firstUseMain = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('firstUseMain', false);
    }

    saveState();

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black54,
            ),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "click_on_the_screen_to_close_the_teaching",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ).tr(),
                        Container(height: 50),
                        Text(
                          'swipe_left_or_right_to_view',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ).tr(),
                        Container(height: 15, width: 1),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            Stack(
                                alignment: Alignment.topCenter,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey,
                                    ),
                                    width: 90,
                                    height: 150,
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    color: Colors.white,
                                    width: 70,
                                    height: 3,
                                  )
                                ]),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1),
                        Text(
                          'tap_the_story_to_enter_full_screen',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ).tr(),
                        Container(height: 15, width: 1),
                        Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey,
                                ),
                                width: 90,
                                height: 150,
                                child: Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                color: Colors.white,
                                width: 70,
                                height: 3,
                              )
                            ]),
                        Container(height: 30, width: 1),
                        Text(
                          'long_press_the_story_to_zoom',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ).tr(),
                        Container(height: 15, width: 1),
                        Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey,
                                  ),
                                  width: 90,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                      Icon(
                                        Icons.touch_app,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                color: Colors.white,
                                width: 70,
                                height: 3,
                              )
                            ]),
                        Container(height: 30, width: 1),
                        Text(
                          'long_press_user_profile_to_call',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ).tr(),
                        Container(height: 15, width: 1),
                        Stack(alignment: Alignment.topRight, children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              SizedBox(width: 10, height: 1),
                              Container(
                                  width: 100, height: 10, color: Colors.grey)
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.touch_app,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          )
                        ]),
                      ],
                    )))),
      ),
    );
  }
}
