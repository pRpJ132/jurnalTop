// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_lessons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayLessons _$DayLessonsFromJson(Map<String, dynamic> json) => DayLessons(
  date: json['date'] as String,
  lesson: (json['lesson'] as num).toInt(),
  startedAt: json['started_at'] as String,
  finishedAt: json['finished_at'] as String,
  subjectName: json['subject_name'] as String,
  teacherName: json['teacher_name'] as String,
  roomName: json['room_name'] as String,
);

Map<String, dynamic> _$DayLessonsToJson(DayLessons instance) =>
    <String, dynamic>{
      'date': instance.date,
      'lesson': instance.lesson,
      'started_at': instance.startedAt,
      'finished_at': instance.finishedAt,
      'subject_name': instance.subjectName,
      'teacher_name': instance.teacherName,
      'room_name': instance.roomName,
    };
