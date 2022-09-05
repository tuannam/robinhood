import 'package:flutter/material.dart';
import 'package:robinhood/components/loader_widget.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/video_player.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final String link;

  const PlayerWidget({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  VideoPlayerWidget? _videoPlayer;
  var loading = true;

  @override
  void initState() {
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
    print('oxoplayer: ${mediaUrl}');
    _videoPlayer = VideoPlayerWidget(mediaUrl: mediaUrl);
    // _controller = VideoPlayerController.network(mediaUrl, httpHeaders: headers)
    //   ..initialize().then((_) {
    //     setState(() {
    //       _controller?.play();
    //     });
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
      body: LoaderView(
          showLoader: loading,
          child: Center(child: _videoPlayer ?? Container())),
    );
  }
}
