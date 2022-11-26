import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:story_viewer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

adManager() {
  double now = DateTime.now().microsecondsSinceEpoch / 1000000;

  double day = 15;
  int time = (now - MyApp.firstUsed) ~/ 86400;

  String buttonText = tr("close_ad");

  if (MyApp.adSizeH == 0) buttonText = tr("open_ad");

  if (time < day) {
    showDialog(
        context: MyApp.context,
        builder: (context) => AlertDialog(
              backgroundColor: MyApp.themeBg2Color,
              title: Text(
                'advertising',
                style: TextStyle(color: MyApp.themeTextColor),
              ).tr(),
              content: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Flexible(
                    child: Text(
                  tr("advertising_content") + " " + time.toString(),
                  style: TextStyle(height: 1.5, color: MyApp.themeTextColor),
                )),
                Container(height: 10),
                Flexible(
                    child: LinearProgressIndicator(
                  backgroundColor: MyApp.themeBg3Color,
                  value: time / day,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ))
              ])),
              contentPadding:
                  EdgeInsets.only(bottom: 0, top: 20, left: 25, right: 25),
              actions: <Widget>[
                FlatButton(
                    textColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('confirm').tr()),
              ],
            ));
  } else {
    showDialog(
        context: MyApp.context,
        builder: (context) => AlertDialog(
              title: Text(
                'advertising',
                style: TextStyle(color: MyApp.themeTextColor),
              ).tr(),
              backgroundColor: MyApp.themeBg2Color,
              content: SingleChildScrollView(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  'advertising_15D_ago_content',
                  style: TextStyle(height: 1.5, color: MyApp.themeTextColor),
                ).tr(),
                Container(height: 15),
                SizedBox(
                    width: double.infinity,
                    child: OutlineButton(
                      color: MyApp.themeBgColor,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 18,
                          color: MyApp.themeTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (MyApp.adSizeH == 0) {
                          prefs.setBool("openAd", null);
                          MyApp.adSizeH =
                              AdmobBannerSize.BANNER.height.toDouble();
                          MyApp.setMainState();
                        } else {
                          prefs.setBool("openAd", false);
                          MyApp.adSizeH = 0;
                          MyApp.setMainState();
                        }
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: tr("changes_saved"),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[700].withOpacity(0.85),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                    ))
              ])),
            ));
  }
}
