import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:robinhood/components/loader_widget.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/control_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  VideoPlayerController? _controller;
  var loading = true;
  Map<String, String> headers = {};

  @override
  void initState() {
    Wakelock.enable();

    super.initState();
    print('Playing ${widget.link} ...');
    Api.shared.getRealLink((p0) {
      print('real link: $p0');
      setState(() {
        loading = false;
      });
      play(p0);
    }, widget.link);
  }

  void play(String mediaUrl) {
    if (mediaUrl.contains("animevhay")) {
      headers = {'referer': 'https://hayghe.club'};
    }
    print('oxoplayer: ${mediaUrl}');
    _controller = VideoPlayerController.network(mediaUrl, httpHeaders: headers)
      ..initialize().then((_) {
        setState(() {
          _controller?.play();
        });
      });
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    Wakelock.disable();
  }

  void _onPlay() {
    setState(() {
      _controller?.play();
    });
  }

  void _onPause() {
    setState(() {
      _controller?.pause();
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      body: LoaderView(
          showLoader: loading,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                  child: _controller != null && _controller!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : Container()),
              ControlPanel(
                  isPlaying: _controller?.value.isPlaying ?? false,
                  onPause: _onPause,
                  onPlay: _onPlay)
            ],
          )),
    );
    return WillPopScope(onWillPop: _onWillPop, child: scaffold);
  }
}
