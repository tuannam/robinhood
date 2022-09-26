import 'package:floor/floor.dart';

@entity
class Film {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String code;
  int duration, position;

  Film(
      {this.id,
      required this.code,
      required this.duration,
      required this.position});
}

@dao
abstract class FilmDao {
  @Query('Select * from Film')
  Future<List<Film>> findAll();

  @Query('Select * from Film where id = :id')
  Future<Film?> findById(String id);

  @Query('Select * from Film where code like :code')
  Future<Film?> findByCode(String code);

  @insert
  Future<void> insertFilm(Film film);

  @update
  Future<int> updateFilms(List<Film> films);
}
