import 'package:json_annotation/json_annotation.dart';
part 'homework_comment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeworkComment {
  String? textComment;
  String? attachmentPath;
  String? attachment;
  String? dateUpdated;
  String? filename;
  int? mark;
  String? studAnswer;
  String? tmpFile;

  HomeworkComment({
    required this.textComment,
    required this.attachmentPath,
    required this.attachment,
    required this.dateUpdated,
  });

  factory HomeworkComment.fromJson(Map<String, dynamic> json) =>
      _$HomeworkCommentFromJson(json);

  Map<String, dynamic> toJson() => _$HomeworkCommentToJson(this);
}