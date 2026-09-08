import 'package:json_annotation/json_annotation.dart';
part 'day_lessons.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DayLessons {
  String date;
  int lesson;
  String startedAt;
  String finishedAt;
  String subjectName;
  String teacherName;
  String roomName;

  DayLessons({
    required this.date,
    required this.lesson,
    required this.startedAt,
    required this.finishedAt,
    required this.subjectName,
    required this.teacherName,
    required this.roomName,
  });

  factory DayLessons.fromJson(Map<String, dynamic> json) =>
      _$DayLessonsFromJson(json);

  Map<String, dynamic> toJson() => _$DayLessonsToJson(this);
}