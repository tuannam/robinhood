import 'package:flutter/material.dart';
import 'package:robinhood/views/video_details.dart';
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

  Future<void> _onPressed(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoDetailsWidget(videoId: movie.code ?? '');
    }));
    print('pushed');
  }

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        padding: const EdgeInsets.all(3),
        onPressed: () => {_onPressed(context)},
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
