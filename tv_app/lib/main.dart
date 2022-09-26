// ignore_for_file: unnecessary_new

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robinhood/app_config.dart';
import 'package:robinhood/db/database.dart';
import 'views/home.dart';
import 'service/http_overrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final database = await $FloorAppDatabase.databaseBuilder("rh.db").build();
  final filmDao = database.filmDao;
  final configuredApp = AppConfig(filmDao, const MyApp());
  runApp(configuredApp);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          title: 'Robinhood',
          theme: ThemeData(scaffoldBackgroundColor: Colors.black),
          home: const HomePage(),
        ));
  }
}
