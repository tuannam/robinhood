import 'package:flutter/material.dart';
import 'package:robinhood/db/film.dart';

class AppConfig extends InheritedWidget {
  final FilmDao filmDao;

  const AppConfig(this.filmDao, Widget child, {Key? key})
      : super(key: key, child: child);
  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
