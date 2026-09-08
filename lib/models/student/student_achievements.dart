import 'package:json_annotation/json_annotation.dart';
part 'student_achievements.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AchievePoints {
  final int id;
  final int pointsCount;

  AchievePoints({
    required this.id,
    required this.pointsCount,
  });

  factory AchievePoints.fromJson(Map<String, dynamic> json) =>
      _$AchievePointsFromJson(json);

  Map<String, dynamic> toJson() => _$AchievePointsToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class StudentAchievements {
  final int id;
  final String translateKey;
  final bool isActive;
  final List<AchievePoints>? achievePoints;

  StudentAchievements({
    required this.id,
    required this.translateKey,
    required this.isActive,
    this.achievePoints
  });

  factory StudentAchievements.fromJson(Map<String, dynamic> json) =>
      _$StudentAchievementsFromJson(json);

  Map<String, dynamic> toJson() => _$StudentAchievementsToJson(this);

}