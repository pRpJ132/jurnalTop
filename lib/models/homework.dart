import 'package:json_annotation/json_annotation.dart';
import 'package:my_app/models/homework_comment.dart';
import 'package:my_app/models/homework_stud.dart';

part 'homework.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeworkItem {
  String comment;
  String nameSpec;
  String fioTeach;
  DateTime? overdueTime;
  DateTime? creationTime;
  DateTime? completionTime;
  HomeworkComment? homeworkComment;
  HomeworkStud? homeworkStud;
  String theme;
  int status;

  HomeworkItem({
    required this.comment,
    required this.nameSpec,
    required this.fioTeach,
    required this.overdueTime,
    required this.creationTime,
    required this.completionTime,
    required this.homeworkComment,
    required this.theme,
    required this.status,
    required this.homeworkStud
  });

  factory HomeworkItem.fromJson(Map<String, dynamic> json) =>
      _$HomeworkItemFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkItemToJson(this);
}