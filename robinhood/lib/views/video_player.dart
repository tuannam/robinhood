import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
// import 'package:video_player/video_player.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  // VideoPlayerController? _controller;
  InAppWebView? _webView;
  final _options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  var buttonsVisible = false;

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
    final wv = InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(mediaUrl)),
      initialOptions: _options,
    );
    setState(() {
      _webView = wv;
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
      body: Center(
        child: Stack(children: <Widget>[
          _webView ?? Container(),
          Opacity(
            opacity: buttonsVisible ? 1 : 0,
            child: FloatingActionButton(
              autofocus: true,
              onPressed: () {
                setState(() {
                  buttonsVisible = !buttonsVisible;
                });
                // Navigator.of(context).pop(true);
              },
              child: const Icon(Icons.pause),
            ),
          )
        ]),
      ),
    );
  }
}
