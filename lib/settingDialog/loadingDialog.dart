import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() => Future.value(false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 90.0,
            height: 90.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
