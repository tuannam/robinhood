import 'package:flutter/material.dart';
import '../service/api.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
    Api.shared.search((p0) {
      print(p0);
    }, 'woo');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Search"),
    );
  }
}
