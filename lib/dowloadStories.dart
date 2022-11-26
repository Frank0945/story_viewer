import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:story_viewer/mainScreen/storiesDisplay.dart';
import 'package:story_viewer/rank.dart';
import 'package:story_viewer/resetData.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';

dowloadStories(saveAt, String url) async {
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
        MyApp.cookie[0] +
        ";ds_user_id=" +
        MyApp.cookie[0].split("%")[0],
    HttpHeaders.refererHeader: 'https://www.instagram.com/'
  };

  print(headers);

  Options options = Options(headers: headers);
  await dio.get(url, options: options).then((response) {
    if (saveAt != null) {
      MyApp.storyData[saveAt.toString()] = response.data;
      reDisplay(saveAt.toString());
    }
    if (url == MyApp.postersDataUrl) {
      resetData();
      MyApp.posterData = response.data;
      rank();
      MyApp.mainDisplayWidget = StoriesDisplay();
      MyApp.adSizeW = AdmobBannerSize.BANNER.width.toDouble();
      MyApp.setMainState();
    }
  }, onError: (error) {
    print(error.toString());
    //if (url != MyApp.postersDataUrl) MyApp.dowloadUrl.remove(url);
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: tr("check_network_status") + "\n" + error.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700].withOpacity(0.85),
        textColor: Colors.white,
        fontSize: 16.0);
    if (MyApp.refresh) MyApp.setMainState();
  });
}

reDisplay(saveAt) {
  MyApp.setStoryDisplayState();
  if (MyApp.setFullScreenSomeoneStoriesDisplayState != null)
    MyApp.setFullScreenSomeoneStoriesDisplayState();
}
