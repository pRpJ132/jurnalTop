// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestNews _$LatestNewsFromJson(Map<String, dynamic> json) => LatestNews(
  idBbs: (json['id_bbs'] as num).toInt(),
  theme: json['theme'] as String,
  time: DateTime.parse(json['time'] as String),
  viewed: json['viewed'] as bool,
);

Map<String, dynamic> _$LatestNewsToJson(LatestNews instance) =>
    <String, dynamic>{
      'id_bbs': instance.idBbs,
      'theme': instance.theme,
      'time': instance.time.toIso8601String(),
      'viewed': instance.viewed,
    };
