import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:story_viewer/main.dart';
import 'package:story_viewer/resetData.dart';
import 'package:story_viewer/settingDialog/deleteDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../dowloadStories.dart';
import '../loadingListDisplay.dart';

class AccountManager extends Dialog {
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
                      padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("account",
                              style: TextStyle(
                                  fontSize: 20, color: MyApp.themeTextColor)).tr(),
                          FlatButton(
                            child: Icon(
                              Icons.add,
                              color: MyApp.themeTextColor,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              MyApp.mainWebViewCheck = true;
                              Navigator.of(context).pushNamed("/web_login");
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: MyApp.userData.length,
                            itemBuilder: (context, idx) {
                              Color color = Colors.transparent;
                              if (idx == 0) color = MyApp.themeBg3Color;
                              return Column(
                                children: <Widget>[
                                  InkWell(
                                      onLongPress: () {
                                        showDialog<Null>(
                                            context: MyApp.context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return DeleteDialog(idx: idx);
                                            });
                                      },
                                      child: FlatButton(
                                          color: color,
                                          onPressed: () async {
                                            if (idx != 0) {
                                              var cData = MyApp.cookie[idx];
                                              MyApp.cookie.removeAt(idx);
                                              MyApp.cookie.insert(0, cData);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setStringList(
                                                  "cookie", MyApp.cookie);
                                              Navigator.of(context).pop();
                                              resetData();
                                              dowloadStories(
                                                  null, MyApp.postersDataUrl);
                                              MyApp.mainDisplayWidget =
                                                  LoadingListDisplay();
                                              MyApp.adSizeW = 0;
                                              MyApp.setMainState();
                                            }
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: 10,
                                                    bottom: 10,
                                                    top: 10),
                                                width: 45,
                                                height: 45,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                  child: TransitionToImage(
                                                    image: AdvancedNetworkImage(
                                                      MyApp.userData[idx]
                                                          ['userPhoto'],
                                                      useDiskCache: true,
                                                      cacheRule: CacheRule(
                                                          maxAge: Duration(
                                                              days: 1)),
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
                                                  child: Text(
                                                      MyApp.userData[idx]
                                                          ['userName'],
                                                      style: TextStyle(
                                                        color: MyApp
                                                            .themeTextColor,
                                                      ))),
                                            ],
                                          )))
                                ],
                              );
                            })),
                  ],
                ))),
      ),
    );
  }
}
