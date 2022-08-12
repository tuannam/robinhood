import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/video_card.dart';
import '../model/section.dart';

class SectionWidget extends StatefulWidget {
  final List<Movie> movies;
  final String? next;

  const SectionWidget({Key? key, required this.movies, this.next})
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
    this.next = widget.next;

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isLeft = _controller.position.pixels == 0;
        if (!isLeft) {
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
        this.next = section.next ?? '';
      }, this.next ?? '');
    }
    this.next = '';
  }

  bool isLastWidget(int index) {
    return index >= widget.movies.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 300.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext content, int position) {
            return VideoWidget(
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
        ));
  }
}
