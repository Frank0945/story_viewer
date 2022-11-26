import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'imageWidget.dart';
import '../main.dart';

class VideoWidget extends StatefulWidget {
  final String videoUrl;
  final Color loadingColor;
  final double height;
  final double width;
  VideoWidget({
    Key key,
    @required this.videoUrl,
    @required this.loadingColor,
    @required this.height,
    @required this.width,
  }) : super();
  @override
  State<StatefulWidget> createState() {
    return _VideoWidget(
      videoUrl: videoUrl,
      loadingColor: loadingColor,
      height: height,
      width: width,
    );
  }
}

class _VideoWidget extends State<VideoWidget> {
  final String videoUrl;
  final Color loadingColor;
  final double height;
  final double width;
  _VideoWidget({
    Key key,
    @required this.videoUrl,
    @required this.loadingColor,
    @required this.height,
    @required this.width,
  }) : super();
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  double duration = 1;
  double position = 0;
  @override
  void initState() {
    super.initState();

    _videoPlayerController1 = VideoPlayerController.network(videoUrl)
      ..addListener(() {
        duration =
            parseDuration(_videoPlayerController1.value.duration.toString());
        position =
            parseDuration(_videoPlayerController1.value.position.toString());

        setState(() {});
      });

    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: width / height,
        autoPlay: true,
        looping: true,
        showControls: false,
        placeholder: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ImageWidget(
              imageUrl: MyApp.bigImageUrl,
              height: height,
              width: width,
              loadingColor: loadingColor,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          ],
        ));

    MyApp.pauseVideo = () {
      _videoPlayerController1.pause();
    };
    MyApp.playVideo = () {
      _videoPlayerController1.play();
    };
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: width / height,
          child: Stack(
            children: <Widget>[
              Chewie(
                controller: _chewieController,
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.black38,
                  Colors.transparent,
                ], begin: FractionalOffset(0, 0), end: FractionalOffset(0, 1))),
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: SizedBox(
                      height: 4,
                      child: LinearProgressIndicator(
                        value: position / duration,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )))
            ],
          ),
        ));
  }
}

double parseDuration(String s) {
  if (s == "null") return 1;

  int hours = 0;
  int minutes = 0;
  double micros = 0;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  micros = double.parse(parts[parts.length - 1]) * 1000000;

  double time = hours * 120 + minutes * 60 + micros;
  return time;
}
