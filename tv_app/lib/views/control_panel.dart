import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ControlPanel extends StatefulWidget {
  final VideoPlayerController controller;

  const ControlPanel({Key? key, required this.controller}) : super(key: key);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  void _pausePlay() {
    setState(() {
      widget.controller.value.isPlaying
          ? widget.controller.play()
          : widget.controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: _pausePlay,
            icon: Icon(widget.controller.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow)),
        TextButton(onPressed: _pausePlay, child: Text("Next"))
      ],
    );
  }
}
