import 'package:json_annotation/json_annotation.dart';
part 'student_visits.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentVisits {
  final DateTime dateVisit;
  final int? lessonNumber;
  final int? statusWas;
  final int? specId;
  final String teacherName;
  final String specName;
  final String lessonTheme;
  final int? controlWorkMark;
  final int? homeWorkMark;
  final int? labWorkMark;
  final int? classWorkMark;
  final int? practicalWorkMark;
  final int? finalWorkMark;

  StudentVisits({
    required this.dateVisit,
    required this.lessonNumber,
    required this.statusWas,
    required this.specId,
    required this.teacherName,
    required this.specName,
    required this.lessonTheme,
    required this.controlWorkMark,
    required this.homeWorkMark,
    required this.labWorkMark,
    required this.classWorkMark,
    required this.practicalWorkMark,
    required this.finalWorkMark,
  });

  factory StudentVisits.fromJson(Map<String, dynamic> json) =>
      _$StudentVisitsFromJson(json);

  Map<String, dynamic> toJson() => _$StudentVisitsToJson(this);

}