import 'package:flutter/material.dart';
import 'package:robinhood/views/control_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String mediaUrl;

  const VideoPlayerWidget({Key? key, required this.mediaUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  Map<String, String> headers = {};

  @override
  void initState() {
    super.initState();

    if (widget.mediaUrl.contains("animevhay")) {
      headers = {'referer': 'https://hayghe.club'};
    }
    _controller =
        VideoPlayerController.network(widget.mediaUrl, httpHeaders: headers)
          ..initialize().then((_) {
            Wakelock.enable();
            setState(() {
              _controller.play();
            });
          });
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container()),
          ControlPanel(
            controller: _controller,
          )
        ],
      ),
    );
  }
}
