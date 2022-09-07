import 'dart:math';

import 'package:flutter/material.dart';

class ProgressSlider extends StatefulWidget {
  final double value;

  const ProgressSlider({Key? key, required this.value}) : super(key: key);

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width - 100;
    return SizedBox(
      width: maxWidth,
      child: Container(
        height: 5,
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.fromLTRB(50, 10, 50, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            // border: Border.all(color: Colors.red),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: SizedBox(
          width: maxWidth * widget.value,
          child: Container(height: 3, color: Colors.blue),
        ),
      ),
    );
  }
}
