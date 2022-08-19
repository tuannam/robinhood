import 'package:flutter/material.dart';

class LoaderView extends StatelessWidget {
  final Widget child;
  final bool showLoader;

  LoaderView({required this.child, required this.showLoader});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (showLoader)
          const Text(
            "Loading...",
            style: TextStyle(color: Colors.yellow),
          )
        else
          Container()
      ],
    );
  }
}
