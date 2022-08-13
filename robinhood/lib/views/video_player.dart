import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        "https://cdn2.p2pstreaming.tw/bigv2st2hls/2021/newlist/2022/07/01/002/WOO-YOUNG-WOO-1-muxed.mp4/playlist.m3u8?wmsAuthSign=c2VydmVyX3RpbWU9OC8xMy8yMDIyIDQ6MTE6MTggQU0maGFzaF92YWx1ZT1DV2tVdjMwUVRwSE9Pc1h1YWR6UmV3PT0mdmFsaWRtaW51dGVzPTE4MCZpZD00OWJmMDQwODRhZjQ0MmY3YjdjNjMyNDM4MTg3YzRmNw==")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Center(
          child: _controller!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            });
          },
          child: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }
}
