import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/section.dart';

typedef ApiCallback = void Function(dynamic);

class Api {
  final String baseUrl = 'http://10.0.0.83/cgi-bin';
  static final Api shared = Api._internal();
  Api._internal();

  Future<void> getSectionList(ApiCallback callback, {String id = ''}) async {
    final url = '$baseUrl/section_cont.cgi?${id}';
    final response = await http.get(Uri.parse(url));
    final object = json.decode(response.body) as Map<String, dynamic>;
    final tab = object['tab'] as Map<String, dynamic>;
    final sectionList = SectionList.fromJson(tab);
    callback(sectionList);
  }

  Future<void> getItems(ApiCallback callback, String next) async {
    print('next = ${next}');
  }
}
