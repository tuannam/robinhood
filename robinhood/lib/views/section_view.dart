import 'package:flutter/material.dart';

class SectionWidget extends StatefulWidget {
  const SectionWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 360.0,
              color: Colors.red,
            ),
            Container(
              width: 360.0,
              color: Colors.orange,
            ),
            Container(
              width: 360.0,
              color: Colors.pink,
            ),
            Container(
              width: 360.0,
              color: Colors.yellow,
            ),
          ],
        ));
  }
}
