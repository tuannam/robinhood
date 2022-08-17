import 'package:flutter/material.dart';

typedef OnFocus = void Function(bool value);

class SearchButton extends StatefulWidget {
  final OnFocus? onFocus;
  const SearchButton({Key? key, this.onFocus}) : super(key: key);

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  var isSearchFocus = false;

  void _onSearchFocus(bool value) {
    if (widget.onFocus != null) {
      widget.onFocus!(value);
    }

    setState(() {
      isSearchFocus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(isSearchFocus ? 10.0 : 5.0),
        decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(1.0, 0.0), blurRadius: 1)
            ]),
        child: Focus(
          onFocusChange: _onSearchFocus,
          child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white)),
        ));
  }
}
