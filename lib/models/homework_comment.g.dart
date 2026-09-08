// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeworkComment _$HomeworkCommentFromJson(Map<String, dynamic> json) =>
    HomeworkComment(
        textComment: json['text_comment'] as String?,
        attachmentPath: json['attachment_path'] as String?,
        attachment: json['attachment'] as String?,
        dateUpdated: json['date_updated'] as String?,
      )
      ..filename = json['filename'] as String?
      ..mark = (json['mark'] as num?)?.toInt()
      ..studAnswer = json['stud_answer'] as String?
      ..tmpFile = json['tmp_file'] as String?;

Map<String, dynamic> _$HomeworkCommentToJson(HomeworkComment instance) =>
    <String, dynamic>{
      'text_comment': instance.textComment,
      'attachment_path': instance.attachmentPath,
      'attachment': instance.attachment,
      'date_updated': instance.dateUpdated,
      'filename': instance.filename,
      'mark': instance.mark,
      'stud_answer': instance.studAnswer,
      'tmp_file': instance.tmpFile,
    };
