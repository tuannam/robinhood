import 'package:flutter/material.dart';
import 'package:robinhood/model/models.dart';
import 'package:robinhood/views/video_card.dart';
import '../service/api.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Movie>? _movies;

  @override
  void initState() {
    super.initState();
    Api.shared.search((p0) {
      setState(() {
        _movies = p0 as List<Movie>;
      });
    }, 'woo');
  }

  bool isLast(int idx) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var movieCards = (_movies ?? [])
        .map((e) => VideoCard(
              movie: e,
              index: -1,
              isLast: (index) {
                return false;
              },
            ))
        .toList();
    return Scaffold(
        body: Wrap(
      children: movieCards,
    ));
  }
}
