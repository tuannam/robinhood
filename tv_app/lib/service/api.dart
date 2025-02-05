import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/models.dart';
import 'package:flutter/foundation.dart';

typedef ApiCallback = void Function(dynamic);

class Api {
  final String baseUrl =
      kDebugMode ? 'http://10.0.0.83/api' : 'https://robinhood.swiftit.net/api';
  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "X-MOVIE-SITE": "hayghe",
        // "X-MOVIE-SITE": "mphimmoi1",
      };

  static final Api shared = Api._internal();
  Api._internal();

  Future<void> getSectionList(ApiCallback callback, {String id = ''}) async {
    final url = '$baseUrl/section_cont/$id';
    final response = await http.get(Uri.parse(url), headers: headers);
    final object = json.decode(response.body) as Map<String, dynamic>;
    final tab = object['tab'] as Map<String, dynamic>;
    final sectionList = SectionList.fromJson(tab);
    callback(sectionList);
  }

  Future<void> getItems(ApiCallback callback, String next) async {
    final url = '$baseUrl/items_cont/$next';
    final response = await http.get(Uri.parse(url), headers: headers);
    final object = json.decode(response.body) as Map<String, dynamic>;
    final section = Section.fromJson(object);
    callback(section);
  }

  Future<void> getMovieDetails(ApiCallback callback, String videoId) async {
    final url = '$baseUrl/details/$videoId';
    final response = await http.get(Uri.parse(url), headers: headers);
    final list = json.decode(response.body) as List;
    if (list.isNotEmpty) {
      final first = list[0] as Map<String, dynamic>;
      final details = MovieDetails.fromJson(first);
      callback(details);
    } else {
      callback(null);
    }
  }

  Future<void> getRealLink(ApiCallback callback, String link) async {
    final url = '$baseUrl/resolve/$link';
    final response = await http.get(Uri.parse(url), headers: headers);
    final object = json.decode(response.body) as Map<String, dynamic>;
    final realUrl = object['url'];
    callback(realUrl);
  }

  Future<void> search(ApiCallback callback, String keyword) async {
    final url = '$baseUrl/search/${Uri.encodeComponent(keyword)}';
    final response = await http.get(Uri.parse(url), headers: headers);
    final results = json.decode(response.body) as List<dynamic>;
    final movies = results.map((e) => Movie.fromJson(e)).toList();
    callback(movies);
  }
}
