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
  final _font = const TextStyle(fontSize: 18.0);
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
    final row = Row(
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
              style: _font,
            ),
          )),
        ]);
    return row;
  }
}
