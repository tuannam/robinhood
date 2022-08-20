import 'package:flutter/material.dart';
import 'package:robinhood/model/models.dart';
import 'package:robinhood/views/video_card.dart';
import 'package:flutter/services.dart';
import '../service/api.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<Movie>? _movies;
  late FocusNode _keywordFocusNode;
  var busy = false;

  @override
  void initState() {
    super.initState();

    _keywordFocusNode = FocusNode(onKey: (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _keywordFocusNode.nextFocus();
      }
      return KeyEventResult.ignored;
    });
  }

  void _onChanged(String value) {
    if (!busy) {
      busy = true;

      Api.shared.search((p0) {
        setState(() {
          _movies = p0 as List<Movie>;
        });
        busy = false;
      }, value);
    }
  }

  bool isLast(int idx) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var movieCards = Wrap(
      runSpacing: 10,
      spacing: 5,
      children: (_movies ?? [])
          .map((e) => VideoCard(
                movie: e,
                index: -1,
                isLast: (index) {
                  return false;
                },
              ))
          .toList(),
    );

    var searchBar = Container(
        height: 80,
        margin: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.redAccent,
            primaryColorDark: Colors.red,
          ),
          child: TextField(
            focusNode: _keywordFocusNode,
            onChanged: _onChanged,
            autofocus: true,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)),
                hintText: 'Enter the search text',
                labelText: 'Keyword',
                prefixText: ' ',
                suffixStyle: TextStyle(color: Colors.green)),
          ),
        ));

    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar,
            Container(
              margin: const EdgeInsets.all(10),
              child: movieCards,
            )
          ],
        ),
      )),
    );
  }
}
