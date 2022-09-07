import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common.dart';

class ControlPanel extends StatefulWidget {
  final bool isPlaying;
  final Function onPause;
  final Function onPlay;

  const ControlPanel(
      {Key? key,
      required this.isPlaying,
      required this.onPause,
      required this.onPlay})
      : super(key: key);

  @override
  State<ControlPanel> createState() => ControlPanelState();
}

class ControlPanelState extends State<ControlPanel> {
  FocusNode? _playFocusNode;
  FocusNode? _fakeBtnFocusNode;
  var showControls = false;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      padding: const EdgeInsets.all(10),
      height: 100,
      // color: Colors.grey.withOpacity(0.5),
      child: showControls
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ControlButton(
                  focusNode: null,
                  icon: Icons.skip_previous,
                  onTapped: () => {},
                ),
                ControlButton(
                  focusNode: _playFocusNode,
                  icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  onTapped: _onPlayPressed,
                ),
                ControlButton(
                  focusNode: null,
                  icon: Icons.skip_next,
                  onTapped: () => {},
                ),
              ],
            )
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

class ControlButton extends StatefulWidget {
  final FocusNode? focusNode;
  final IconData icon;
  final Function onTapped;
  const ControlButton({
    Key? key,
    required this.focusNode,
    required this.icon,
    required this.onTapped,
  }) : super(key: key);

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  var isFocus = false;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  void onTapped() {
    print('onTapped');
    widget.onTapped();
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    if (ACCEPT_KEYS.contains(event.logicalKey)) {
      onTapped();
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        focusNode: widget.focusNode,
        onFocusChange: _onFocus,
        onKey: _onKey,
        child: InkWell(
          onTap: () {
            onTapped();
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            color: isFocus
                ? Colors.blue.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            child: Icon(
              widget.icon,
              size: 40,
              color: Colors.yellow,
            ),
          ),
        ));
  }
}
