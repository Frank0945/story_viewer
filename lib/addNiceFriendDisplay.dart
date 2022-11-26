import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class AddNiceFriendDisplay extends Dialog {
  final String id;
  final int idx;
  AddNiceFriendDisplay({@required this.id, @required this.idx}) : super();
  @override
  Widget build(BuildContext context) {
    String text = tr("set_priority");
    if (MyApp.priority.indexOf(id) != -1) text = tr("cancel_priority");
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
                margin: EdgeInsets.only(right: 40, left: 40),
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  color: MyApp.themeBg2Color,
                  onPressed: () async {
                    Map data = MyApp.order[idx];
                    if (text == tr("set_priority")) {
                      MyApp.order.removeAt(idx);
                      MyApp.order.insert(0, data);
                      MyApp.priority.remove(id);
                      MyApp.priority.insert(0, id);
                    } else {
                      MyApp.priority.remove(id);
                      MyApp.order.removeAt(idx);

                      int insertIdx = MyApp.beforeRank[id];
                      if (MyApp.priority.length > insertIdx)
                        insertIdx = MyApp.priority.length;

                      MyApp.order.insert(insertIdx, data);
                    }
                    MyApp.setRankStoryDisplayState();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setStringList(
                        "priority" + MyApp.cookie[0], MyApp.priority);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16, color: MyApp.themeTextColor),
                  ),
                ))),
      ),
    );
  }
}
