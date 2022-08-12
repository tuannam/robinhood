import 'package:flutter/material.dart';
import '../model/section.dart';

class VideoWidget extends StatefulWidget {
  final Movie movie;

  const VideoWidget({Key? key, required this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoWidgetState(movie);
}

class _VideoWidgetState extends State<VideoWidget> {
  _VideoWidgetState(this.movie);

  final Movie movie;
  var isFocus = false;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  void _onPressed() {
    print('pressed: ${movie.title}');
  }

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        padding: const EdgeInsets.all(3),
        onPressed: _onPressed,
        icon: Image.network(
          movie.image ?? '',
          fit: BoxFit.fill,
        ));
    var focusedButton = Focus(
      onFocusChange: _onFocus,
      child: iconButton,
    );
    return Container(
      color: isFocus ? Colors.red : Colors.transparent,
      child: SizedBox(
        width: 200.0,
        child: AspectRatio(
          aspectRatio: 200 / 300,
          child: focusedButton,
        ),
      ),
    );
  }
}
