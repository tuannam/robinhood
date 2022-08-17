import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robinhood/views/video_details.dart';
import '../model/section.dart';

typedef IS_LAST_WIDGET = bool Function(int index);

class VideoCard extends StatefulWidget {
  final Movie movie;
  final int index;
  final IS_LAST_WIDGET isLast;

  const VideoCard(
      {Key? key,
      required this.movie,
      required this.index,
      required this.isLast})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  final _titleFont = const TextStyle(fontSize: 10.0, color: Colors.white);
  var isFocus = false;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    print('key = ${event.logicalKey}');
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VideoDetailsWidget(videoId: widget.movie.code ?? '');
      }));
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        widget.isLast(widget.index)) {
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizedBox = SizedBox(
      width: 150,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 150 / 225,
            child: Container(
                padding: EdgeInsets.all(5),
                child: Image.network(
                  widget.movie.image ??
                      'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
                  fit: BoxFit.fill,
                )),
          ),
          Text(
            widget.movie.title ?? '',
            style: _titleFont,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );

    return Focus(
        onFocusChange: _onFocus,
        onKey: _onKey,
        child: Container(
          color: isFocus ? Colors.red : Colors.transparent,
          child: sizedBox,
        ));
  }
}
