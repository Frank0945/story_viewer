import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/settingDialog/darkMode.dart';
import 'package:story_viewer/teach/teachers.dart';
import '../main.dart';
import './adManager.dart';
import '../launchURL.dart';
import 'dowloadUserData.dart';
import 'loadingDialog.dart';
import 'package:easy_localization/easy_localization.dart';

class Setting extends Dialog {
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
                margin: EdgeInsets.only(right: 40, left: 40),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog<Null>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return LoadingDialog();
                                      });
                                  dowloadUserData();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.account_circle,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      "account_management",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog<Null>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return DarkMode();
                                      });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.brightness_2,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'dark_mode',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog<Null>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return Teachers();
                                      });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.help_outline,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'use_teaching',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  launchURL(
                                      'https://play.google.com/store/apps/details?id=com.story_viewer');
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.thumb_up,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'give_evaluation',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed("/web_userTerm");
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.library_books,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'user_terms',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  launchURL(
                                      'mailto:yuanchuang940@gmail.com?subject=【Story Viewer】' +
                                          'bug_report'.tr());
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.bug_report,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'bug_report',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  launchURL(
                                      'https://www.buymeacoffee.com/yuanchuang');
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.card_giftcard,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'donate_btn',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  adManager();
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.donut_large,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'advertising',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                        Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                                onPressed: () {
                                  launchURL(
                                      'https://github.com/Frank0945/story_viewer');
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.code,
                                      color: MyApp.themeTextColor,
                                    ),
                                    Container(width: 15),
                                    Text(
                                      'view_code',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                  ],
                                ))),
                      ],
                    )
                  ],
                ))),
      ),
    );
  }
}
