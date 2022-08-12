import 'dart:io';

import 'package:flutter/material.dart';
import '../model/section.dart';
import '../service/api.dart';

class VideoDetailsWidget extends StatefulWidget {
  final String videoId;

  const VideoDetailsWidget({Key? key, required this.videoId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoDetailsState(videoId);
}

class _VideoDetailsState extends State<VideoDetailsWidget> {
  final _contentFont = const TextStyle(fontSize: 16.0);
  final String videoId;
  MovieDetails? details;

  _VideoDetailsState(this.videoId);

  @override
  void initState() {
    super.initState();

    Api.shared.getMovieDetails((p0) {
      if (p0 != null) {
        final movieDetails = p0 as MovieDetails;
        print(movieDetails.title);
        setState(() {
          details = movieDetails;
        });
      }
    }, videoId);
  }

  @override
  Widget build(BuildContext context) {
    final row1 = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: 320,
              height: 240,
              child: AspectRatio(
                aspectRatio: 320 / 240,
                child: Image.network(
                  details?.image ?? '',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            child: Text(
              Uri.decodeComponent(details?.content ?? ''),
              style: _contentFont,
            ),
          )),
        ]);
    final chapters = Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: (details?.links ?? [])
              .map((e) => ChapterButton(link: e))
              .toList()),
    );
    final column = Column(
      children: [row1, chapters],
    );
    return SingleChildScrollView(
      child: column,
    );
  }
}

class ChapterButton extends StatefulWidget {
  final MovieLink link;

  const ChapterButton({Key? key, required this.link}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterButtonState();
}

class _ChapterButtonState extends State<ChapterButton> {
  final _chapterFont = const TextStyle(fontSize: 18.0);
  bool isFocus = false;

  void _onFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
        onFocusChange: _onFocus,
        child: Container(
          color: isFocus ? Colors.yellow : Colors.transparent,
          child: TextButton(
              onPressed: () {},
              child: Text(
                widget.link.name,
                style: _chapterFont,
              )),
        ));
  }
}
