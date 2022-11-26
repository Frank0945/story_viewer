import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

rank() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MyApp.priority = prefs.getStringList("priority" + MyApp.cookie[0]);
  if (MyApp.priority == null) MyApp.priority = [];

  MyApp.seenMedia = prefs.getStringList('seen' + MyApp.cookie[0]);
  if (MyApp.seenMedia == null) MyApp.seenMedia = [];

  int max = MyApp
      .posterData['data']['user']['feed_reels_tray']['edge_reels_tray_to_reel']
          ['edges']
      .length;

  int down = 0;
  List<String> seenUserList = [];

  for (int i = 0; i < max; i++) {
    Map data = MyApp.posterData['data']['user']['feed_reels_tray']
        ['edge_reels_tray_to_reel']['edges'][i];
    MyApp.beforeRank[data['node']['id']] = i;
    data['uniId'] = i;

    if (MyApp.priority.indexOf(data['node']['id']) != -1)
      MyApp.order.insert(0, data);
    else {
      int lastMedia = data['node']['latest_reel_media'];
      String userId = data['node']['id'];

      if (MyApp.seenMedia.indexOf("$userId:$lastMedia") == -1) {
        MyApp.order.insert(MyApp.order.length - down, data);
      } else {
        seenUserList.add("$userId:$lastMedia");
        down += 1;
        MyApp.order.insert(MyApp.order.length, data);
      }
    }
  }

  MyApp.seenMedia = seenUserList;
}
