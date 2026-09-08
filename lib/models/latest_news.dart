import 'package:json_annotation/json_annotation.dart';
part 'latest_news.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LatestNews {
  int idBbs;
  String theme;
  DateTime time;
  bool viewed;

  LatestNews({
    required this.idBbs,
    required this.theme,
    required this.time,
    required this.viewed,
  });

  factory LatestNews.fromJson(Map<String, dynamic> json) =>
      _$LatestNewsFromJson(json);

  Map<String, dynamic> toJson() => _$LatestNewsToJson(this);
}