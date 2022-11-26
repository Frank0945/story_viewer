import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final Color loadingColor;
  final double height;
  final double width;
  ImageWidget({
    Key key,
    @required this.imageUrl,
    @required this.loadingColor,
    @required this.height,
    @required this.width,
  }) : super();
  @override
  Widget build(BuildContext context) {

    return TransitionToImage(
      key: key,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      image: AdvancedNetworkImage(
        imageUrl,
        useDiskCache: true,
        cacheRule: CacheRule(maxAge: Duration(hours: 3)),
      ),
      loadingWidgetBuilder: (BuildContext context, double progress, list) =>
          Container(
              decoration: BoxDecoration(
                  color: loadingColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: height,
              width: width,
              child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                      backgroundColor: Colors.white30,
                      value: progress))),
      placeholder: Container(
        decoration: BoxDecoration(
            color: loadingColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: height,
        width: width,
        child: Icon(Icons.error_outline),
      ),
      enableRefresh: true,
    );
  }
}
