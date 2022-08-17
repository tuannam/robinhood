import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnFocus = void Function(bool value);
typedef OnSeachPressed = void Function();

class SearchButton extends StatefulWidget {
  final OnFocus? onFocus;
  final OnSeachPressed onSearch;
  const SearchButton({Key? key, this.onFocus, required this.onSearch})
      : super(key: key);

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

    print('_onSearchFocus');
  }

  KeyEventResult _onKey(FocusNode node, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      widget.onSearch();
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(isSearchFocus ? 20.0 : 15.0),
        decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(1.0, 0.0), blurRadius: 1)
            ]),
        child: Focus(
          onFocusChange: _onSearchFocus,
          onKey: _onKey,
          child: const Icon(Icons.search, color: Colors.white),
        ));
  }
}
