import 'package:flutter/material.dart';
import 'package:robinhood/controls/control_button.dart';
import 'package:robinhood/controls/slider.dart';
import '../common.dart';

class ControlPanel extends StatefulWidget {
  final bool isPlaying;
  final double percentPlayed;
  final String duration;
  final String position;
  final Function onPause;
  final Function onPlay;
  final Function onFastFoward;
  final Function onFastRewind;

  const ControlPanel(
      {Key? key,
      required this.isPlaying,
      required this.percentPlayed,
      required this.duration,
      required this.position,
      required this.onPause,
      required this.onPlay,
      required this.onFastFoward,
      required this.onFastRewind})
      : super(key: key);

  @override
  State<ControlPanel> createState() => ControlPanelState();
}

class ControlPanelState extends State<ControlPanel> {
  FocusNode? _playFocusNode;
  FocusNode? _fakeBtnFocusNode;
  var showControls = false;
  var progress = 0.0;
  final timeTextStyle = const TextStyle(color: Colors.yellow, fontSize: 16);

  @override
  void initState() {
    super.initState();

    _playFocusNode = FocusNode();
    _fakeBtnFocusNode = FocusNode(
      onKey: (node, event) {
        if (ACCEPT_KEYS.contains(event.logicalKey)) {
          onShowControls();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
    _fakeBtnFocusNode?.requestFocus();
  }

  void onShowControls() {
    setState(() {
      showControls = true;
    });
    _playFocusNode?.requestFocus();
  }

  void onHideControls() {
    setState(() {
      showControls = false;
    });
    _fakeBtnFocusNode?.requestFocus();
  }

  void _onPlayPressed() {
    if (widget.isPlaying) {
      widget.onPause();
    } else {
      widget.onPlay();
    }
  }

  void _onFastFoward() {
    widget.onFastFoward();
  }

  void _onFastRewind() {
    widget.onFastRewind();
  }

  @override
  Widget build(BuildContext context) {
    var buttons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ControlButton(
          focusNode: null,
          icon: Icons.fast_rewind,
          onTapped: _onFastRewind,
        ),
        ControlButton(
          focusNode: _playFocusNode,
          icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
          onTapped: _onPlayPressed,
        ),
        ControlButton(
          focusNode: null,
          icon: Icons.fast_forward,
          onTapped: _onFastFoward,
        ),
      ],
    );
    final maxWidth = MediaQuery.of(context).size.width - 100;
    var timeLine = SizedBox(
      width: maxWidth,
      child: Container(
          margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Row(
            children: [
              Text(
                widget.position,
                style: timeTextStyle,
              ),
              const Spacer(),
              Text(
                widget.duration,
                style: timeTextStyle,
              )
            ],
          )),
    );
    var controls = Column(
      children: [
        buttons,
        ProgressSlider(
          value: widget.percentPlayed,
        ),
        timeLine
      ],
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      padding: const EdgeInsets.all(10),
      height: 120,
      // color: Colors.grey.withOpacity(0.5),
      child: showControls
          ? controls
          : Focus(
              focusNode: _fakeBtnFocusNode,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.blue.withOpacity(0.0),
              )),
    );
  }
}
