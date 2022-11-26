import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:story_viewer/resetData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'package:easy_localization/easy_localization.dart';

class DeleteDialog extends Dialog {
  final int idx;
  DeleteDialog({@required this.idx}) : super();
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
                margin: EdgeInsets.only(right: 50, left: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          color: MyApp.themeBg2Color,
                          onPressed: () async {
                            MyApp.cookie.removeAt(idx);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setStringList("cookie", MyApp.cookie);
                            if (idx == 0) {
                              MyApp.mainFirst = true;
                              resetData();
                              MyApp.adSizeW = 0;
                              MyApp.setMainState();
                            }
                            Fluttertoast.showToast(
                                msg: tr("sign_out_successfully"),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Colors.grey[700].withOpacity(0.8),
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'sign_out',
                            style: TextStyle(
                                fontSize: 17, color: Colors.redAccent),
                          ).tr(),
                        ))
                  ],
                ))),
      ),
    );
  }
}
