// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_stud.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeworkStud _$HomeworkStudFromJson(Map<String, dynamic> json) => HomeworkStud(
  id: (json['id'] as num).toInt(),
  autoMark: json['auto_mark'] as bool,
  creationTime: DateTime.parse(json['creation_time'] as String),
  filePath: json['file_path'] as String?,
  filename: json['filename'] as String?,
  mark: (json['mark'] as num?)?.toInt(),
  studAnswer: json['stud_answer'] as String?,
  tmpFile: json['tmp_file'] as String?,
);

Map<String, dynamic> _$HomeworkStudToJson(HomeworkStud instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auto_mark': instance.autoMark,
      'creation_time': instance.creationTime.toIso8601String(),
      'file_path': instance.filePath,
      'filename': instance.filename,
      'mark': instance.mark,
      'stud_answer': instance.studAnswer,
      'tmp_file': instance.tmpFile,
    };
