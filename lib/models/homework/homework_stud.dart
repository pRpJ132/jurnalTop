import 'package:json_annotation/json_annotation.dart';
part 'homework_stud.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeworkStud {
  int id;
  bool autoMark;
  DateTime creationTime;
  String? filePath;
  String? filename;
  int? mark;
  String? studAnswer;
  String? tmpFile;

  HomeworkStud({
    required this.id,
    required this.autoMark,
    required this.creationTime,
    required this.filePath,
    required this.filename,
    required this.mark,
    required this.studAnswer,
    required this.tmpFile,
  });

  factory HomeworkStud.fromJson(Map<String, dynamic> json) =>
      _$HomeworkStudFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkStudToJson(this);
}