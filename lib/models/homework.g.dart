// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeworkItem _$HomeworkItemFromJson(Map<String, dynamic> json) => HomeworkItem(
  comment: json['comment'] as String,
  nameSpec: json['name_spec'] as String,
  fioTeach: json['fio_teach'] as String,
  overdueTime: json['overdue_time'] == null
      ? null
      : DateTime.parse(json['overdue_time'] as String),
  creationTime: json['creation_time'] == null
      ? null
      : DateTime.parse(json['creation_time'] as String),
  completionTime: json['completion_time'] == null
      ? null
      : DateTime.parse(json['completion_time'] as String),
  homeworkComment: json['homework_comment'] == null
      ? null
      : HomeworkComment.fromJson(
          json['homework_comment'] as Map<String, dynamic>,
        ),
  theme: json['theme'] as String,
  status: (json['status'] as num).toInt(),
  homeworkStud: json['homework_stud'] == null
      ? null
      : HomeworkStud.fromJson(json['homework_stud'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeworkItemToJson(HomeworkItem instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'name_spec': instance.nameSpec,
      'fio_teach': instance.fioTeach,
      'overdue_time': instance.overdueTime?.toIso8601String(),
      'creation_time': instance.creationTime?.toIso8601String(),
      'completion_time': instance.completionTime?.toIso8601String(),
      'homework_comment': instance.homeworkComment,
      'homework_stud': instance.homeworkStud,
      'theme': instance.theme,
      'status': instance.status,
    };
