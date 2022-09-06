import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robinhood/views/video_details.dart';
import '../model/models.dart';
import '../common.dart';

typedef IS_LAST_WIDGET = bool Function(int index);
typedef OPEN_DRAWER = void Function();

class VideoCard extends StatefulWidget {
  final OPEN_DRAWER openDrawer;
  final Movie movie;
  final int index;
  final IS_LAST_WIDGET isLast;

  const VideoCard(
      {Key? key,
      required this.openDrawer,
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
  var lastLeftTapped = DateTime.now().millisecondsSinceEpoch;
  var lastShowDetails = DateTime.now().millisecondsSinceEpoch;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    print('onKey: ${event.logicalKey}');

    if (ACCEPT_KEYS.contains(event.logicalKey)) {
      navToDetails();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        widget.isLast(widget.index)) {
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
        widget.index == 0) {
      var delta = DateTime.now().millisecondsSinceEpoch - lastLeftTapped;
      if (delta > 2000) {
        // widget.openDrawer();
      }
      lastLeftTapped = DateTime.now().millisecondsSinceEpoch;

      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  void navToDetails() {
    if (DateTime.now().millisecondsSinceEpoch - lastShowDetails < 1000) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoDetailsWidget(videoId: widget.movie.code ?? '');
    }));
    lastShowDetails = DateTime.now().millisecondsSinceEpoch;
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
        child: InkWell(
          onTap: () => {navToDetails()},
          child: Container(
            color: isFocus ? Colors.red : Colors.transparent,
            child: sizedBox,
          ),
        ));
  }
}
