import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:easy_localization/easy_localization.dart';

class DarkMode extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DarkMode();
}

class _DarkMode extends State<DarkMode> {
  bool setMeState = false;
  @override
  Widget build(BuildContext context) {
    Widget _more = SizedBox();
    bool _value1 = false;
    bool _value2 = false;

    var startTime = '6:00 PM';
    var endTime = '6:00 AM';

    if (MyApp.darkModeTime[2] != null) {
      _value2 = true;

      startTime = timeChange(MyApp.darkModeTime[0]);
      endTime = timeChange(MyApp.darkModeTime[1]);

      int darkModeTimeStartH = int.parse(MyApp.darkModeTime[0].split(':')[0]);
      int darkModeTimeStartM = int.parse(MyApp.darkModeTime[0].split(':')[1]);
      int darkModeTimeEndH = int.parse(MyApp.darkModeTime[1].split(':')[0]);
      int darkModeTimeEndM = int.parse(MyApp.darkModeTime[1].split(':')[1]);

      int i = darkModeTimeStartH;

      while (true) {
        if (i == 25) i = 0;
        i += 1;
        if (i == 24) {
          if (darkModeTimeStartH == darkModeTimeEndH) {
            if (darkModeTimeEndM < darkModeTimeStartM) {
              endTime = tr("next_day") + ' ' + endTime;
            }
          } else {
            endTime = tr("next_day") + ' ' + endTime;
          }
          break;
        }
        if (i == darkModeTimeEndH) break;
      }

      _more = Column(
        children: <Widget>[
          FlatButton(
              onPressed: () {
                _showTimePicker(0, MyApp.darkModeTime[0]);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'starting_time',
                        style: TextStyle(
                            color: MyApp.themeTextColor, fontSize: 15),
                      ).tr(),
                      Flexible(
                          child: Text(
                        startTime,
                        style: TextStyle(color: Colors.blue[400], fontSize: 18),
                      )),
                    ],
                  ))),
          Container(
              margin: EdgeInsets.only(right: 15, left: 15),
              color: MyApp.themeBg3Color,
              height: 0.8),
          FlatButton(
              onPressed: () {
                _showTimePicker(1, MyApp.darkModeTime[1]);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'end_time',
                        style: TextStyle(
                            color: MyApp.themeTextColor, fontSize: 15),
                      ).tr(),
                      Flexible(
                          child: Text(
                        endTime,
                        softWrap: true,
                        style: TextStyle(color: Colors.blue[400], fontSize: 18),
                      )),
                    ],
                  ))),
        ],
      );
    } else {
      if (MyApp.themeBgColor != Colors.white) _value1 = true;
    }

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          if (MyApp.darkModeTime[2] != null) {
                            if (MyApp.themeBgColor != Colors.white) {
                              setMeState = true;
                              MyApp.themeBgColor = Colors.white;
                            }
                          }
                          MyApp.darkModeTime[2] = null;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              'darkModeTime', MyApp.darkModeTime);
                          openCloseDarkMode(true);
                          setState(() {});
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "open_now",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: MyApp.themeTextColor,
                                  ),
                                ).tr(),
                                Switch(
                                  activeColor: Colors.blue[400],
                                  value: _value1,
                                  onChanged: (newValue) async {
                                    if (MyApp.darkModeTime[2] != null) {
                                      if (MyApp.themeBgColor != Colors.white) {
                                        setMeState = true;
                                        MyApp.themeBgColor = Colors.white;
                                      }
                                    }
                                    MyApp.darkModeTime[2] = null;
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setStringList(
                                        'darkModeTime', MyApp.darkModeTime);
                                    openCloseDarkMode(true);
                                    setState(() {});
                                  },
                                )
                              ],
                            ))),
                    Container(
                        margin: EdgeInsets.only(right: 15, left: 15),
                        color: MyApp.themeBg3Color,
                        height: 0.8),
                    FlatButton(
                        onPressed: () async {
                          if (MyApp.darkModeTime[2] == null) {
                            MyApp.darkModeTime[2] = 'open';
                            timeOpenCloseDarkMode();
                          } else {
                            MyApp.darkModeTime[2] = null;
                            if (MyApp.themeBgColor != Colors.white)
                              openCloseDarkMode(false);
                            else
                              setState(() {});
                          }
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setStringList(
                              'darkModeTime', MyApp.darkModeTime);
                          prefs.setBool("darkMode", null);
                          setState(() {});
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 15, top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "open_at_scheduled_time",
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: MyApp.themeTextColor,
                                      ),
                                    ).tr(),
                                    SizedBox(height: 5),
                                    Text(
                                      "open_at_scheduled_time_content",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ).tr(),
                                  ],
                                )),
                                Expanded(
                                    flex: 0,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Switch(
                                            activeColor: Colors.blue[400],
                                            value: _value2,
                                            onChanged: (newValue) async {
                                              if (MyApp.darkModeTime[2] ==
                                                  null) {
                                                MyApp.darkModeTime[2] = 'open';
                                                timeOpenCloseDarkMode();
                                              } else {
                                                MyApp.darkModeTime[2] = null;
                                                if (MyApp.themeBgColor !=
                                                    Colors.white)
                                                  openCloseDarkMode(false);
                                                else
                                                  setState(() {});
                                              }
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setStringList(
                                                  'darkModeTime',
                                                  MyApp.darkModeTime);
                                              prefs.setBool("darkMode", null);
                                              setState(() {});
                                            }))),
                              ],
                            ))),
                    _more
                  ],
                ))),
      ),
    );
  }

  _showTimePicker(which, String time) async {
    int hour = int.parse(time.split(':')[0]);
    int minute = int.parse(time.split(':')[1]);

    await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    ).then((timeOfDay) async {
      if (timeOfDay == null) return;

      String data = '${timeOfDay.hour}:${timeOfDay.minute}';

      MyApp.darkModeTime[which] = data;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('darkModeTime', MyApp.darkModeTime);

      timeOpenCloseDarkMode();
      setState(() {});
    });
  }

  timeOpenCloseDarkMode() {
    int darkModeTimeStartH = int.parse(MyApp.darkModeTime[0].split(':')[0]);
    int darkModeTimeStartM = int.parse(MyApp.darkModeTime[0].split(':')[1]);
    int darkModeTimeEndH = int.parse(MyApp.darkModeTime[1].split(':')[0]);
    int darkModeTimeEndM = int.parse(MyApp.darkModeTime[1].split(':')[1]);

    int nowH = DateTime.now().hour;
    int nowM = DateTime.now().minute;

    bool needChangeToBlack;

    int i = darkModeTimeStartH;

    while (true) {
      if (i == nowH) {
        if (darkModeTimeStartH == darkModeTimeEndH) {
          if (darkModeTimeStartM < darkModeTimeEndM &&
              nowM >= darkModeTimeStartM &&
              nowM < darkModeTimeEndM)
            needChangeToBlack = true;
          else if (darkModeTimeStartM > darkModeTimeEndM) {
            int x = darkModeTimeStartM;
            while (true) {
              if (x == nowM) {
                needChangeToBlack = true;
                break;
              }
              if (x == darkModeTimeEndM - 1) break;
              x += 1;
              if (x == 60) x = 0;
            }
          }
        } else {
          if (darkModeTimeStartH == nowH) {
            if (darkModeTimeStartM <= nowM) needChangeToBlack = true;
          } else if (darkModeTimeEndH == nowH) {
            if (darkModeTimeEndM > nowM) needChangeToBlack = true;
          } else {
            needChangeToBlack = true;
          }
        }
        break;
      }
      if (i == darkModeTimeEndH) break;
      i += 1;
      if (i == 25) i = 0;
    }

    if (needChangeToBlack == true) {
      if (MyApp.themeBgColor == Colors.white)
        openCloseDarkMode(false);
      else
        setState(() {});
    } else {
      if (MyApp.themeBgColor != Colors.white)
        openCloseDarkMode(false);
      else
        setState(() {});
    }
  }

  openCloseDarkMode(bool saveAtDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (MyApp.themeBgColor == Colors.white) {
      if (saveAtDarkMode) prefs.setBool('darkMode', true);
      MyApp.themeBgColor = Colors.black;
      MyApp.themeBg2Color = Colors.grey[850];
      MyApp.themeLoadColor = Colors.grey[600];
      MyApp.themeBg3Color = Colors.grey[700];
      MyApp.themeTextColor = Colors.white;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: MyApp.themeBgColor,
          systemNavigationBarColor: MyApp.themeBgColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light));
    } else {
      if (saveAtDarkMode) prefs.setBool('darkMode', null);
      MyApp.themeBgColor = Colors.white;
      MyApp.themeBg2Color = Colors.white;
      MyApp.themeLoadColor = Colors.white;
      MyApp.themeBg3Color = Colors.grey[200];
      MyApp.themeTextColor = Colors.black;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: MyApp.themeBgColor,
          systemNavigationBarColor: MyApp.themeBgColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark));
    }
    if (!setMeState) {
      MyApp.refresh = true;
      MyApp.setMainState();
    } else {
      setMeState = false;
      setState(() {});
    }
  }
}

timeChange(String time) {
  String apm = 'AM';
  String hour = time.split(':')[0];
  String minute = time.split(':')[1];

  if (int.parse(hour) >= 12) {
    hour = (int.parse(hour) - 12).toString();
    apm = "PM";
  }
  if (int.parse(hour) < 10) hour = "0" + hour;
  if (int.parse(hour) == 0) hour = "12";

  if (int.parse(minute) < 10) minute = "0" + minute;

  return ("$hour:$minute $apm");
}
