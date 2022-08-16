import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/video_player.dart';
import 'package:robinhood/views/webview_player.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  WebViewWidget? _webView;
  VideoPlayerWidget? _videoPlayer;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    print('Playing ${widget.link} ...');
    Api.shared.getRealLink((p0) {
      print('real link: $p0');
      play(p0);
    }, widget.link);
  }

  void play(String mediaUrl) {
    if (mediaUrl.contains('ok.ru')) {
      print('webview');
      setState(() {
        _webView = WebViewWidget(url: mediaUrl);
      });
    } else {
      print('oxoplayer');
      // _videoPlayer = VideoPlayerWidget(mediaUrl: mediaUrl);
      _controller = VideoPlayerController.network(mediaUrl)
        ..initialize().then((_) {
          setState(() {
            _controller?.play();
          });
        });
    }
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
              : _webView ?? Container()),
    );
  }
}
