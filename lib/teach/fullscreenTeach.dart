import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FullscreenTeach extends Dialog {
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
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black54,
            ),
            child: SingleChildScrollView(
                child: Container(
                    width: double.infinity,
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
                                      Icons.person,
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
                          'swipe_up_to_see_the_same',
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
                                        Icons.arrow_upward,
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
                          'swipe_down_to_leave',
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
                                        Icons.arrow_downward,
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
                          'click_left/right',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ).tr(),
                        Container(height: 15, width: 1),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
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
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: <Widget>[
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
                            Container(
                                height: 150, width: 8, color: Colors.black26),
                          ],
                        ),
                        Container(height: 30, width: 1),
                        Text(
                          'long_press_on_the_screen',
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
                                        Icons.pause_circle_outline,
                                        color: Colors.white,
                                        size: 35,
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
                      ],
                    )))),
      ),
    );
  }
}
