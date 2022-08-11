// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionList _$SectionListFromJson(Map<String, dynamic> json) => SectionList(
      (json['sections'] as List<dynamic>)
          .map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next'] as String?,
    );

Map<String, dynamic> _$SectionListToJson(SectionList instance) =>
    <String, dynamic>{
      'sections': instance.sections.map((e) => e.toJson()).toList(),
      'next': instance.next,
    };

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      json['title'] as String?,
      (json['items'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next'] as String?,
    );

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
      'title': instance.title,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next': instance.next,
    };

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      json['article_code'] as String?,
      json['article_title'] as String?,
      json['article_image'] as String?,
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'article_code': instance.code,
      'article_title': instance.title,
      'article_image': instance.image,
    };
