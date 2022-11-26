import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:easy_localization/easy_localization.dart';

showAskDialog() {
  showDialog(
      barrierDismissible: false,
      context: MyApp.context,
      builder: (context) => AlertDialog(
            title: Text('questionnaire').tr(),
            content: Text(
              'questionnaire_content',
              style: TextStyle(height: 1.5),
            ).tr(),
            contentPadding:
                EdgeInsets.only(bottom: 0, top: 20, left: 25, right: 25),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('refuse').tr()),
              FlatButton(
                  textColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed("/web_ask");
                  },
                  child: Text('confirm').tr()),
            ],
          ));
}
