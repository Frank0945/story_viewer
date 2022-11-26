import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryLineProgress extends StatefulWidget {
  final Color backgroundColor;
  final Color valueColor;
  final double height;
  final double padding;
  final int value;
  final int maxValue;
  StoryLineProgress({
    @required this.backgroundColor,
    @required this.height,
    @required this.padding,
    @required this.value,
    @required this.valueColor,
    @required this.maxValue,
  }) : super();
  @override
  State<StatefulWidget> createState() {
    return _StoryLineProgress(
      backgroundColor: backgroundColor,
      height: height,
      padding: padding,
      value: value,
      valueColor: valueColor,
      maxValue: maxValue,
    );
  }
}

class _StoryLineProgress extends State<StoryLineProgress> {
  final Color backgroundColor;
  final Color valueColor;
  final double height;
  final double padding;
  final int value;
  final int maxValue;
  _StoryLineProgress({
    @required this.backgroundColor,
    @required this.height,
    @required this.padding,
    @required this.value,
    @required this.valueColor,
    @required this.maxValue,
  }) : super();
  @override
  Widget build(BuildContext context) {
    List<Widget> lineWidget = [];

    Widget idxWidget = Expanded(
        child:  Container(
      margin: EdgeInsets.only(left: padding, right: padding),
      color: valueColor,
      height: height,
    ));

    Widget otherWidget = Expanded(
        child: Container(
      margin: EdgeInsets.only(left: padding, right: padding),
      color: backgroundColor,
      height: height,
    ));

    for (int i = 0; i < maxValue; i++) {
      if (i == value) {
        lineWidget.add(idxWidget);
      } else {
        lineWidget.add(otherWidget);
      }
    }

    return Row(children: lineWidget);
  }
}
