import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:robinhood/components/loader_widget.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/controls/control_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

extension DurationExtension on Duration {
  String _readableTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = this.inHours;
    final minutes = this.inMinutes.remainder(60);
    final seconds = this.inSeconds.remainder(60);
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  String get readableTime => _readableTime();
}

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  GlobalKey<ControlPanelState> _controlPanelKey = GlobalKey();
  VideoPlayerController? _controller;
  var loading = true;
  var percentPlayed = 0.0;
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
    _controller?.addListener(() {
      setState(() {
        percentPlayed = _controller!.value.position.inSeconds /
            _controller!.value.duration.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    Wakelock.disable();
  }

  void _play() {
    setState(() {
      _controller?.play();
    });
  }

  void _pause() {
    setState(() {
      _controller?.pause();
    });
  }

  void _fastFoward() {
    setState(() {
      var current = _controller?.value.position.inSeconds ?? 0;
      _controller?.seekTo(Duration(seconds: current + 30));
      _controller?.play();
    });
  }

  void _fastRewind() {
    setState(() {
      var current = _controller?.value.position.inSeconds ?? 0;
      _controller?.seekTo(Duration(seconds: current - 30));
      _controller?.play();
    });
  }

  Future<bool> _onWillPop() async {
    if (_controlPanelKey.currentState?.showControls ?? false) {
      _controlPanelKey.currentState?.onHideControls();
    } else {
      Navigator.of(context).pop();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var controlPanel = ControlPanel(
      key: _controlPanelKey,
      isPlaying: _controller?.value.isPlaying ?? false,
      percentPlayed: percentPlayed,
      duration: _controller?.value.duration.readableTime ?? "00:00:00",
      position: _controller?.value.position.readableTime ?? "00:00:00",
      onPause: _pause,
      onPlay: _play,
      onFastFoward: _fastFoward,
      onFastRewind: _fastRewind,
    );

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
              controlPanel
            ],
          )),
    );
    return WillPopScope(onWillPop: _onWillPop, child: scaffold);
  }
}
