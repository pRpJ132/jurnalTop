// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_achievements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievePoints _$AchievePointsFromJson(Map<String, dynamic> json) =>
    AchievePoints(
      id: (json['id'] as num).toInt(),
      pointsCount: (json['points_count'] as num).toInt(),
    );

Map<String, dynamic> _$AchievePointsToJson(AchievePoints instance) =>
    <String, dynamic>{'id': instance.id, 'points_count': instance.pointsCount};

StudentAchievements _$StudentAchievementsFromJson(Map<String, dynamic> json) =>
    StudentAchievements(
      id: (json['id'] as num).toInt(),
      translateKey: json['translate_key'] as String,
      isActive: json['is_active'] as bool,
      achievePoints: (json['achieve_points'] as List<dynamic>?)
          ?.map((e) => AchievePoints.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StudentAchievementsToJson(
  StudentAchievements instance,
) => <String, dynamic>{
  'id': instance.id,
  'translate_key': instance.translateKey,
  'is_active': instance.isActive,
  'achieve_points': instance.achievePoints,
};
