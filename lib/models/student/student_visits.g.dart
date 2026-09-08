// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_visits.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentVisits _$StudentVisitsFromJson(Map<String, dynamic> json) =>
    StudentVisits(
      dateVisit: DateTime.parse(json['date_visit'] as String),
      lessonNumber: (json['lesson_number'] as num?)?.toInt(),
      statusWas: (json['status_was'] as num?)?.toInt(),
      specId: (json['spec_id'] as num?)?.toInt(),
      teacherName: json['teacher_name'] as String,
      specName: json['spec_name'] as String,
      lessonTheme: json['lesson_theme'] as String,
      controlWorkMark: (json['control_work_mark'] as num?)?.toInt(),
      homeWorkMark: (json['home_work_mark'] as num?)?.toInt(),
      labWorkMark: (json['lab_work_mark'] as num?)?.toInt(),
      classWorkMark: (json['class_work_mark'] as num?)?.toInt(),
      practicalWorkMark: (json['practical_work_mark'] as num?)?.toInt(),
      finalWorkMark: (json['final_work_mark'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StudentVisitsToJson(StudentVisits instance) =>
    <String, dynamic>{
      'date_visit': instance.dateVisit.toIso8601String(),
      'lesson_number': instance.lessonNumber,
      'status_was': instance.statusWas,
      'spec_id': instance.specId,
      'teacher_name': instance.teacherName,
      'spec_name': instance.specName,
      'lesson_theme': instance.lessonTheme,
      'control_work_mark': instance.controlWorkMark,
      'home_work_mark': instance.homeWorkMark,
      'lab_work_mark': instance.labWorkMark,
      'class_work_mark': instance.classWorkMark,
      'practical_work_mark': instance.practicalWorkMark,
      'final_work_mark': instance.finalWorkMark,
    };
