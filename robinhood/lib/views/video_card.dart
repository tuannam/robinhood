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

  Future<void> _onPressed(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoDetailsWidget(videoId: widget.movie.code ?? '');
    }));
    print('pushed');
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    print('key = ${event.logicalKey}');
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        widget.isLast(widget.index)) {
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        padding: const EdgeInsets.all(3),
        onPressed: () => {_onPressed(context)},
        icon: Image.network(
          widget.movie.image ??
              'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930',
          fit: BoxFit.fill,
        ));
    var focusedButton = Focus(
      onFocusChange: _onFocus,
      onKey: _onKey,
      child: iconButton,
    );

    final sizedBox = SizedBox(
      width: 150,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 150 / 225,
            child: focusedButton,
          ),
          Text(
            widget.movie.title ?? '',
            style: _titleFont,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );

    return Container(
      color: isFocus ? Colors.red : Colors.transparent,
      child: sizedBox,
    );
  }
}
