// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewsStudent _$ReviewsStudentFromJson(Map<String, dynamic> json) =>
    ReviewsStudent(
      spec: json['spec'] as String,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
      fullSpec: json['full_spec'] as String,
      teacher: json['teacher'] as String,
    );

Map<String, dynamic> _$ReviewsStudentToJson(ReviewsStudent instance) =>
    <String, dynamic>{
      'spec': instance.spec,
      'message': instance.message,
      'date': instance.date.toIso8601String(),
      'full_spec': instance.fullSpec,
      'teacher': instance.teacher,
    };
