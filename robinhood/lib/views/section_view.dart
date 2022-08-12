import 'package:flutter/material.dart';
import 'package:robinhood/service/api.dart';
import 'package:robinhood/views/video_view.dart';
import '../model/section.dart';

class SectionWidget extends StatefulWidget {
  final List<Movie> movies;
  final next;

  const SectionWidget({Key? key, required this.movies, required this.next})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SectionWidgetState(movies, next);
  }
}

class _SectionWidgetState extends State<SectionWidget> {
  final List<Movie> movies;
  String? next;
  final _controller = ScrollController();

  _SectionWidgetState(this.movies, this.next);

  @override
  void initState() {
    super.initState();
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
    if (next != '') {
      Api.shared.getItems((p0) {
        final section = p0 as Section;
        setState(() {
          movies.addAll(section.items);
        });
        next = section.next ?? '';
      }, next ?? '');
    }
    next = '';
  }

  void _onPressed() {
    print('pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 300.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext content, int position) {
            return VideoWidget(movie: movies[position]);
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: movies.length,
          controller: _controller,
        ));
  }
}
