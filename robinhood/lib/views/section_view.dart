import 'package:flutter/material.dart';
import '../model/section.dart';

class SectionWidget extends StatefulWidget {
  final Section section;

  const SectionWidget({Key? key, required this.section}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SectionWidgetState(section);
}

class _SectionWidgetState extends State<SectionWidget> {
  final Section section;
  _SectionWidgetState(this.section);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext content, int position) {
              return Container(
                width: 360.0,
                color: position % 2 == 0 ? Colors.red : Colors.yellow,
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: section.items.length));
  }
}
