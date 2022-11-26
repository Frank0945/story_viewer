import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import 'accountManager.dart';

dowloadUserData() {
  MyApp.userData = [];
  _dowload(0);
}

_dowload(idx) async {
  String url = "https://www.instagram.com/settings/help/";

  Dio dio = Dio();
  dio.options.receiveTimeout = 25000;
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    client.userAgent = null;
    return client;
  };

  Map<String, dynamic> headers = Map();

  headers = {
    HttpHeaders.userAgentHeader: MyApp.userAgent,
    HttpHeaders.cookieHeader: 'sessionid=' +
        MyApp.cookie[idx] +
        ";ds_user_id=" +
        MyApp.cookie[idx].split("%")[0],
    HttpHeaders.refererHeader: 'https://www.instagram.com/',
  };

  Options options = Options(headers: headers);

  await dio.get(url, options: options).then((response) {
    String data = response.data;
    String userPhoto = data
        .split('profile_pic_url_hd\\":\\"')[1]
        .split('\\"')[0]
        .replaceAll('\\/', '/')
        .replaceAll("\\u0026", "&")
        .replaceAll('\\', '');
    String userName = data.split('username\\":\\"')[1].split('\\"')[0];

    MyApp.userData.insert(idx, {
      "userPhoto": userPhoto,
      "userName": userName,
    });

    if (MyApp.cookie.length - 1 > idx) {
      _dowload(idx + 1);
    } else if (MyApp.cookie.length - 1 <= idx) {
      _checkRepeat();
      Navigator.of(MyApp.context).pop();
      showDialog<Null>(
          context: MyApp.context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AccountManager();
          });
    }
  }, onError: (error) {
    Navigator.of(MyApp.context).pop();
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: tr("check_network_status"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700].withOpacity(0.85),
        textColor: Colors.white,
        fontSize: 16.0);
  });
}

_checkRepeat() {
  for (int i = 0; i < MyApp.cookie.length; i++) {
    for (int j = i + 1; j < MyApp.cookie.length; j++) {
      if (MyApp.userData[i]['userPhoto'] == MyApp.userData[j]['userPhoto']) {
        MyApp.userData.removeAt(j);
        MyApp.cookie.removeAt(j);
      }
    }
  }
}
