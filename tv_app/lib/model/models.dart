import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable(explicitToJson: true)
class SectionList {
  final List<Section> sections;
  final String? next;

  SectionList(this.sections, this.next);
  factory SectionList.fromJson(Map<String, dynamic> json) =>
      _$SectionListFromJson(json);
  Map<String, dynamic> toJson() => _$SectionListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Section {
  final String? title;
  final List<Movie> items;
  final String? next;

  Section(this.title, this.items, this.next);

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}

@JsonSerializable()
class Movie {
  @JsonKey(name: 'article_code')
  final String? code;

  @JsonKey(name: 'article_title')
  final String? title;

  @JsonKey(name: 'article_image')
  final String? image;

  Movie(this.code, this.title, this.image);

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class MovieDetails {
  @JsonKey(name: "article_title")
  final String title;

  @JsonKey(name: "article_image")
  final String image;

  @JsonKey(name: "article_content")
  final String content;

  @JsonKey(name: "extra_info")
  final List<ServerDetails> servers;

  MovieDetails(this.title, this.image, this.content, this.servers);

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);
}

@JsonSerializable()
class ServerDetails {
  @JsonKey(name: "server")
  final String name;

  @JsonKey(name: "chapters")
  final List<MovieLink> links;

  ServerDetails(this.name, this.links);
  factory ServerDetails.fromJson(Map<String, dynamic> json) =>
      _$ServerDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ServerDetailsToJson(this);
}

@JsonSerializable()
class MovieLink {
  final String name;
  final String link;

  MovieLink(this.name, this.link);

  factory MovieLink.fromJson(Map<String, dynamic> json) =>
      _$MovieLinkFromJson(json);
  Map<String, dynamic> toJson() => _$MovieLinkToJson(this);
}
