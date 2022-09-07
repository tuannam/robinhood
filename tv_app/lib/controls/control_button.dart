import 'package:flutter/material.dart';
import '../common.dart';

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
