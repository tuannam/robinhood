import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:robinhood/db/film.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Film])
abstract class AppDatabase extends FloorDatabase {
  FilmDao get filmDao;
}
