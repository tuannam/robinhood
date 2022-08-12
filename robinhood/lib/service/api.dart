import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/section.dart';

typedef ApiCallback = void Function(dynamic);

class Api {
  final String baseUrl = 'http://robinhood.swiftit.net/cgi-bin';
  static final Api shared = Api._internal();
  Api._internal();

  Future<void> getSectionList(ApiCallback callback, {String id = ''}) async {
    final url = '$baseUrl/section_cont.cgi?$id';
    final response = await http.get(Uri.parse(url));
    final object = json.decode(response.body) as Map<String, dynamic>;
    final tab = object['tab'] as Map<String, dynamic>;
    final sectionList = SectionList.fromJson(tab);
    callback(sectionList);
  }

  Future<void> getItems(ApiCallback callback, String next) async {
    final url = '$baseUrl/items_cont.cgi?$next';
    final response = await http.get(Uri.parse(url));
    final object = json.decode(response.body) as Map<String, dynamic>;
    final section = Section.fromJson(object);
    callback(section);
  }

  Future<void> getMovieDetails(ApiCallback callback, String videoId) async {
    final url = '$baseUrl/details.cgi?$videoId';
    final response = await http.get(Uri.parse(url));
    final list = json.decode(response.body) as List;
    if (list.isNotEmpty) {
      final first = list[0] as Map<String, dynamic>;
      final details = MovieDetails.fromJson(first);
      callback(details);
    } else {
      callback(null);
    }
  }
}
