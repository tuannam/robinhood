import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    print('Playing ${widget.link} ...');
    Api.shared.getRealLink((p0) {
      print('real link: $p0');
      if (p0.startsWith('https://www.ok.ru')) {
        resolveOkRu(p0);
      } else {
        play(p0);
      }
    }, widget.link);
  }

  void resolveOkRu(String url) {
    Api.shared.getMediaUrlFromOkRu((p0) {
      print('media url: $p0');
      play(p0);
    }, url);
  }

  void play(String mediaUrl) {
    _controller = VideoPlayerController.network(mediaUrl)
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
    return Scaffold(
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
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
        child: _controller != null
            ? Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              )
            : Container(),
      ),
    );
    // return MaterialApp(
    //   theme: ThemeData(scaffoldBackgroundColor: Colors.black),
    //   home: Scaffold(
    //     body: Center(
    //       child: _controller != null && _controller!.value.isInitialized
    //           ? AspectRatio(
    //               aspectRatio: _controller!.value.aspectRatio,
    //               child: VideoPlayer(_controller!),
    //             )
    //           : Container(),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         setState(() {
    //           _controller!.value.isPlaying
    //               ? _controller!.pause()
    //               : _controller!.play();
    //         });
    //       },
    //       child: _controller != null
    //           ? Icon(
    //               _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
    //             )
    //           : Container(),
    //     ),
    //   ),
    // );
  }
}
