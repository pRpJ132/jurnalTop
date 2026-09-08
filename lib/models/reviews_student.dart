import 'package:json_annotation/json_annotation.dart';
part 'reviews_student.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewsStudent {
  String spec;
  String message;
  DateTime date;
  String fullSpec;
  String teacher;

  ReviewsStudent({
    required this.spec,
    required this.message,
    required this.date,
    required this.fullSpec,
    required this.teacher,
  });

  factory ReviewsStudent.fromJson(Map<String, dynamic> json) =>
      _$ReviewsStudentFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsStudentToJson(this);
}