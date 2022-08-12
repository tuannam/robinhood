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
  final String videoId;
  MovieDetails? details;

  _VideoDetailsState(this.videoId);

  @override
  void initState() {
    super.initState();

    Api.shared.getMovieDetails((p0) {
      if (p0 != null) {
        setState(() {
          details = p0 as MovieDetails;
        });
      }
    }, videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Text(details?.title ?? '');
  }
}
