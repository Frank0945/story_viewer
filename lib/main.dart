import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:story_viewer/mainScreen/sotriesDisplay2.dart';
import 'package:story_viewer/mainScreen/storiesDisplay1.dart';
import 'package:story_viewer/dowloadStories.dart';
import 'package:story_viewer/loadingListDisplay.dart';
import 'package:story_viewer/loginPage.dart';
import 'package:story_viewer/resetData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List cookie = prefs.getStringList("cookie");
  if (cookie != null) MyApp.cookie = cookie;

  String userAgent = prefs.getString("user-agent");
  if (userAgent != null) MyApp.userAgent = userAgent;

  double firstUsed = prefs.getDouble("firstUsed");
  if (firstUsed == null) {
    MyApp.firstUsed = DateTime.now().microsecondsSinceEpoch / 1000000;
    prefs.setDouble(
        'firstUsed', DateTime.now().microsecondsSinceEpoch / 1000000);
  } else {
    MyApp.firstUsed = firstUsed;
  }

  await DiskCache().clear();

  void _isDarkMode(darkMode) {
    if (darkMode != null) {
      MyApp.themeBgColor = Colors.black;
      MyApp.themeBg2Color = Colors.grey[850];
      MyApp.themeLoadColor = Colors.grey[600];
      MyApp.themeBg3Color = Colors.grey[700];
      MyApp.themeTextColor = Colors.white;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: MyApp.themeBgColor,
          systemNavigationBarColor: MyApp.themeBgColor,
          statusBarIconBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: MyApp.themeBgColor,
          statusBarIconBrightness: Brightness.dark));
    }
  }

  List darkModeTime = prefs.getStringList("darkModeTime");
  if (darkModeTime != null) {
    MyApp.darkModeTime = darkModeTime;
    String darkModeTimeOpen = darkModeTime[2];

    if (darkModeTimeOpen != null) {
      int darkModeTimeStartH = int.parse(darkModeTime[0].split(':')[0]);
      int darkModeTimeStartM = int.parse(darkModeTime[0].split(':')[1]);
      int darkModeTimeEndH = int.parse(darkModeTime[1].split(':')[0]);
      int darkModeTimeEndM = int.parse(darkModeTime[1].split(':')[1]);

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

      _isDarkMode(needChangeToBlack);
    } else {
      bool darkMode = prefs.getBool("darkMode");
      _isDarkMode(darkMode);
    }
  } else {
    bool darkMode = prefs.getBool("darkMode");
    _isDarkMode(darkMode);
  }

  Admob.initialize();

  bool openAd = prefs.getBool("openAd");
  if (openAd == null) {
    MyApp.adSizeH = AdmobBannerSize.BANNER.height.toDouble();
  } else {
    MyApp.adSizeH = 0;
  }

  int loginDays = prefs.getInt("loginDays");
  if (loginDays == null)
    loginDays = 1;
  else if (loginDays <= 45) {
    loginDays += 1;
  }

  if (loginDays <= 45) prefs.setInt("loginDays", loginDays);
  MyApp.loginDays = loginDays;

  bool giveStarWindow = prefs.getBool("giveStarWindow");
  if (loginDays >= 20 && giveStarWindow == null) {
    MyApp.giveStarWindow = true;
    prefs.setBool("giveStarWindow", true);
  }

  MyApp.firstUseMain = prefs.getBool("firstUseMain");
  MyApp.firstUseFullScreen = prefs.getBool("firstUseFullScreen");

  int dis = prefs.getInt("display");
  if (dis == 1) {
    MyApp.displayStory = StoriesDisplay1();
    MyApp.displayIcon = Icons.widgets;
  } else {
    MyApp.displayStory = StoriesDisplay2();
    MyApp.displayIcon = Icons.format_list_bulleted;
  }

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('zh')],
        path: 'assets/translations',
        saveLocale: true,
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  static List<String> darkModeTime = ['18:0', '6:0', null];
  static bool refresh = false;
  static Function setMainStoryDisplayState;
  static double firstUsed;
  static bool firstUseFullScreen = false;
  static bool firstUseMain = false;
  static bool giveStarWindow;
  static int loginDays;
  static Widget bigImageBackground;
  static String bannerId =
      'ca-app-pub-1252176697811343/3192006529'; // ca-app-pub-3940256099942544/6300978111 //ca-app-pub-1252176697811343/3192006529
  static List<String> cookie = [];
  static String userAgent;
  static IconData displayIcon;
  static Widget displayStory;
  static String postersDataUrl =
      'https://instagram.com/graphql/query/?query_hash=b40536160b85d87aecc43106a1f35495';

  static Map posterData = {};
  static Map storyData = {};
  static Map setSomeoneStoriesDisplayState = {};
  static double storyHeight = 220;
  static Function bigImage;
  static Function outBigImage;
  static String bigImageUrl;
  static String bigVideoUrl;
  static Map<String, double> bigVideoSize = {};
  static var canScroll;
  static int fullScreenPage = 0;
  static bool fullScreenIsAnimtae = false;
  static Function setFullScreenStoriesDisplayState;
  static PageController fullScreenPageController;
  static List dowloadUid = [];
  static Function setMainState;
  static Widget mainDisplayWidget = LoadingListDisplay();
  static bool mainWebViewCheck = false;
  static Function setStoryDisplayState;
  static Function setFullScreenSomeoneStoriesDisplayState;
  static Function pauseVideo;
  static Function playVideo;
  static Map fullScreenStoryPage = {};
  static String storyUrl;
  static Map jump = {};
  static Map display2Height = {};
  static ScrollController stroiesDisplayController;
  static double storiesDisplay2Height;
  static bool jumpMode = false;
  static Map storyBordier = {};
  static List<String> priority = [];
  static List order = [];
  static List userData = [];
  static BuildContext context;
  static bool mainFirst = true;
  static double adSizeW = 0;
  static double adSizeH;
  static bool adOffstage = false;
  static Function setRankStoryDisplayState;
  static Map beforeRank = {};
  static bool canSetHeight = true;
  static List<String> seenMedia = [];
  static List<int> expiredMedia = [];
  static Color themeBgColor = Colors.white;
  static Color themeBg2Color = Colors.white;
  static Color themeLoadColor = Colors.white;
  static Color themeBg3Color = Colors.grey[200];
  static Color themeTextColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
        ),
        home: MyHomePage(),
        routes: {
          "/web_login": (_) => WebviewScaffold(
                url:
                    'https://www.instagram.com/accounts/login/?source=auth_switcher',
                clearCookies: true,
                withLocalStorage: false,
                hidden: true,
                /* userAgent:
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36',*/
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: Text('login').tr(),
                ),
              ),
          "/web_ask": (_) => WebviewScaffold(
                url:
                    'https://docs.google.com/forms/d/e/1FAIpQLSdA29w_gEovQKNpeQ86-4JSTM3s1bHjANABkHSy-ipm4Oe53Q/viewform',
                hidden: true,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: Text("questionnaire").tr(),
                ),
              ),
          "/web_userTerm": (_) => WebviewScaffold(
                url:
                    'https://frank0945.github.io/yuanchuangWebsite/story_viewer/',
                hidden: true,
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: Text('user_terms').tr(),
                ),
              )
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int key = 0;
  @override
  Widget build(BuildContext context) {
    MyApp.context = context;

    if (MyApp.canSetHeight) {
      MyApp.storiesDisplay2Height =
          (MediaQuery.of(context).size.width / 2 - 20) * 2;
      MyApp.storyHeight = MediaQuery.of(context).size.height / 2 -
          90 -
          MediaQuery.of(context).padding.top;
    }
    MyApp.setMainState = () {
      if (MyApp.refresh) {
        MyApp.refresh = false;
        key += 1;
      }
      setState(() {});
    };

    if (MyApp.mainWebViewCheck) {
      MyApp.mainWebViewCheck = false;
      final flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.onUrlChanged.listen((String url) async {
        if (url == 'https://www.instagram.com/' ||
            url == 'https://www.instagram.com' ||
            url.contains('https://www.instagram.com/accounts/onetap')) {
          resetData();

          SharedPreferences prefs = await SharedPreferences.getInstance();

          final String result = await flutterWebviewPlugin
              .getAllCookies('https://www.instagram.com/');

          final future =
              flutterWebviewPlugin.evalJavascript("window.navigator.userAgent");
          future.then((String result) {
            print(result);
            prefs.setString("user-agent", result);
            MyApp.userAgent = result;
          });

          flutterWebviewPlugin.close();
          Navigator.pop(context);

          MyApp.adSizeW = 0;
          MyApp.mainDisplayWidget = LoadingListDisplay();
          MyApp.setMainState();

          MyApp.cookie.insert(0, result.split('sessionid=')[1].split(';')[0]);

          print(result.split('sessionid=')[1].split(';')[0]);

          prefs.setStringList("cookie", MyApp.cookie);
          dowloadStories(null, MyApp.postersDataUrl);
        }
      });
    }
    if (MyApp.mainWebViewCheck || MyApp.mainFirst) {
      MyApp.mainFirst = false;
      if (MyApp.cookie.length != 0) {
        MyApp.adSizeW = 0;
        MyApp.mainDisplayWidget = LoadingListDisplay();
        dowloadStories(null, MyApp.postersDataUrl);
      } else {
        final flutterWebviewPlugin = FlutterWebviewPlugin();
        flutterWebviewPlugin.cleanCookies();
        MyApp.mainDisplayWidget = LoginPage();
      }
    }

    Widget adWidget = Container(
        height: MyApp.adSizeH,
        width: MyApp.adSizeW,
        color: MyApp.themeBgColor,
        child: AdmobBanner(
          adUnitId: MyApp.bannerId,
          adSize: AdmobBannerSize.BANNER,
          listener: (AdmobAdEvent event, Map<String, dynamic> args) {
            if (event == AdmobAdEvent.failedToLoad) {
              MyApp.adOffstage = true;
              setState(() {});
              print(
                  'Admob banner failed to load. Error code: ${args['errorCode']}');
            }
          },
        ));
    if (MyApp.adOffstage) adWidget = SizedBox();

    return Stack(
        key: ValueKey(key),
        alignment: Alignment.bottomCenter,
        children: <Widget>[MyApp.mainDisplayWidget, adWidget]);
  }
}
