import 'package:flutter/material.dart';
import 'package:story_viewer/main.dart';
import 'package:easy_localization/easy_localization.dart';

import 'launchURL.dart';

showGiveStarDialog() {
  showDialog(
      barrierDismissible: false,
      context: MyApp.context,
      builder: (context) => AlertDialog(
            title: Text('give_us_a_review').tr(),
            content: Text(
              'give_us_a_review_content',
              style: TextStyle(height: 1.5),
            ).tr(),
            contentPadding:
                EdgeInsets.only(bottom: 0, top: 20, left: 25, right: 25),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context), child: Text('refuse').tr()),
              FlatButton(
                  textColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pop(context);
                    launchURL(
                        'https://play.google.com/store/apps/details?id=com.story_viewer');
                  },
                  child: Text('confirm').tr()),
            ],
          ));
}
