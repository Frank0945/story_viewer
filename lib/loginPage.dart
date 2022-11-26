import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Image.asset(
                      'assets/images/login_page_cover.png',
                    )),
                    Padding(
                        padding: EdgeInsets.only(bottom: 50, top: 50),
                        child: RaisedButton(
                          onPressed: () {
                            MyApp.mainWebViewCheck = true;
                            Navigator.of(context).pushNamed("/web_login");
                          },
                          textColor: Colors.white,
                          padding: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.deepPurple[300],
                                    Colors.purple[300],
                                    Colors.red[300],
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(90))),
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Text('Login to Instagram',
                                style: TextStyle(fontSize: 20)),
                          ),
                        )),
                  ],
                ))));
  }
}
