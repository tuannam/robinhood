import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
// import 'package:video_player/video_player.dart';
import 'package:robinhood/views/webview_player.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  // VideoPlayerController? _controller;
  WebViewWidget? _webView;

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
    setState(() {
      _webView = WebViewWidget(url: mediaUrl);
    });
    // _controller = VideoPlayerController.network(mediaUrl)
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _webView ?? Container()),
    );
  }
}
