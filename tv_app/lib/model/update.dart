import 'package:json_annotation/json_annotation.dart';
part 'update.g.dart';

@JsonSerializable()
class Update {
  final String version;
  final String url;

  Update(this.version, this.url);
  factory Update.fromJson(Map<String, dynamic> json) => _$UpdateFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateToJson(this);
}
