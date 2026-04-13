import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/models/student_achievements.dart';
import 'package:my_app/network/api_client.dart';

class AwardsScreen extends StatefulWidget {
  const AwardsScreen({super.key});

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  final ValueNotifier<List<StudentAchievements>> _achievements = ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

   @override
    void dispose() {
      super.dispose();
      _isLoading.dispose();
      _achievements.dispose();
    }

  void _loadAll() async {
    _isLoading.value = true;
    await _loadAssessments();
    _isLoading.value = false;
  }

  Future<void> _loadAssessments() async {
    final response = await ApiClient.get(
      "profile/statistic/student-achievements"
    );

    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      _achievements.value = body.map<StudentAchievements>((el) => StudentAchievements.fromJson(el)).toList();
    }
  }

  final translateKeys = {
    "5_VISITS_WITHOUT_GAP": "5 посещений подряд без пропусков",
    "10_VISITS_WITHOUT_GAP": "10 посещений подряд без пропусков",
    "20_VISITS_WITHOUT_GAP": "20 посещений подряд без пропусков",
    "5_VISITS_WITHOUT_DELAY": "5 посещений подряд без опозданий",
    "10_VISITS_WITHOUT_DELAY": "10 посещений подряд без опозданий",
    "20_VISITS_WITHOUT_DELAY": "20 посещений подряд без опозданий",
    "SOCIAL_ACTIVITY": "Социальная активность",
    "FILL_IN_PROFILE": "Полностью заполненный профиль",
    "FRIEND_OF_ACADEMY": "Привел друга учиться в TOP",
    "STEP_TSHIRT": "Посещение академии в футболке с логотипом «TOP»",
    "SURVEY": "Участие в опросе",
    "COMPETITION": "Участие в конкурсе",
    "EMAIL_CONFIRMATION": "Подтверждение электронной почты",
    "SOCIAL_REVIEW": "Публикация отзыва"
  };

  final imageKeys = {
    "5_VISITS_WITHOUT_GAP": "fox-5.png",
    "10_VISITS_WITHOUT_GAP": "fox-10.png",
    "20_VISITS_WITHOUT_GAP": "fox-20.png",
    "10_VISITS_WITHOUT_DELAY": null,
    "20_VISITS_WITHOUT_DELAY": null,
    "SOCIAL_ACTIVITY": null,
    "FILL_IN_PROFILE": null,
    "FRIEND_OF_ACADEMY": null,
    "STEP_TSHIRT": null,
    "SURVEY": null,
    "COMPETITION": null,
    "EMAIL_CONFIRMATION": null,
    "SOCIAL_REVIEW": null
  };

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (_, isLoadingValue, _) {
        if(isLoadingValue) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 9.0, top: 14),
                  child: Text(
                    "Ваши награды".toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ValueListenableBuilder(
                    valueListenable: _achievements,
                    builder: (_, achievementsValue, _) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemCount: achievementsValue.length,
                        itemBuilder: (context, index) => _buildContainerAwards(achievementsValue[index]),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildContainerAwards(StudentAchievements sa) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return ColorFiltered(
                colorFilter: sa.isActive
                    ? ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : ColorFilter.matrix(<double>[
                        0.1126, 0.9192, 0.0022, 0, 0,
                        0.1126, 0.9192, 0.0022, 0, 0,
                        0.1126, 0.9192, 0.0022, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                child: Image.asset(
                  imageKeys[sa.translateKey] != null
                      ? "assets/animals/${imageKeys[sa.translateKey]}"
                      : "assets/animals/lion.png",
                  width: width * 0.35,
                ),
              );
            }
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  return Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    translateKeys[sa.translateKey] ?? sa.translateKey,
                    style: TextStyle(
                      fontSize: width * 0.08
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            spacing: 12,
            mainAxisAlignment: .center,
            children: sa.achievePoints?.map(
              (el) => el.pointsCount != 0 ? Row(
                spacing: 6,
                mainAxisSize: .min,
                children: [
                  Flexible(
                    child: Text(
                      "+${el.pointsCount}"
                    )
                  ),
                  Image.asset(
                    height: MediaQuery.of(context).size.width < 400 ? 10 : 20,
                    el.id == 1 
                      ? "assets/top-coin.png" 
                      : "assets/top-gem.png",
                    fit: BoxFit.contain,
                  ),
                ],
              ) : SizedBox.shrink()
            ).toList() ?? [],
          ),
        ],
      ),
    );
  }
}