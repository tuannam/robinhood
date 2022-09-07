import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/video_card.dart';
import '../model/models.dart';

class SectionWidget extends StatefulWidget {
  final OPEN_DRAWER openDrawer;
  final String category;
  final List<Movie> movies;
  final String? next;

  const SectionWidget(
      {Key? key,
      required this.openDrawer,
      required this.category,
      required this.movies,
      this.next})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  final _controller = ScrollController();
  String? next;

  @override
  void initState() {
    super.initState();
    next = widget.next;

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isLeft = _controller.position.pixels == 0;
        if (isLeft) {
          // widget.openDrawer();
        } else {
          // isRight
          print('Reach End.');
          loadNext();
        }
      }
    });
  }

  void loadNext() {
    if (widget.next != '') {
      Api.shared.getItems((p0) {
        final section = p0 as Section;
        setState(() {
          widget.movies.addAll(section.items);
        });
        next = section.next ?? '';
      }, next ?? '');
    }
    next = '';
  }

  bool isLastWidget(int index) {
    return index >= widget.movies.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 20.0, 0, 5.0),
          child: Text(
            widget.category,
            style: const TextStyle(color: Colors.orange),
          ),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            // color: Colors.yellow,
            height: 263.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext content, int position) {
                return VideoCard(
                  openDrawer: widget.openDrawer,
                  movie: widget.movies[position],
                  index: position,
                  isLast: isLastWidget,
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: widget.movies.length,
              controller: _controller,
            )),
      ],
    );
  }
}
