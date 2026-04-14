import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/models/student_achievements.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                valueListenable: _isLoading,
                builder: (_, isLoadingValue, _) {
                  if (isLoadingValue) {
                    return Skeletonizer(
                      enabled: isLoadingValue,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemCount: translateKeys.length,
                        itemBuilder: (context, index) {
                          StudentAchievements newAchievementsValue = StudentAchievements(
                            id: -1,
                            translateKey: "5_VISITS_WITHOUT_GAP", 
                            isActive: false,
                          );
                          return _buildContainerAwards(newAchievementsValue);
                        },
                      ),
                    );
                  }
                  return ValueListenableBuilder(
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
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildContainerAboutAwardGem(),
                  _buildContainerAboutAwardCoin(),
                  _buildContainerAboutAwardAchievements()
                ],
              ),
            )
          ],
        ),
      ),
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

  Widget _buildContainerAboutAwardGem() {
    return Container(
      padding: EdgeInsets.all(33),
      color: Colors.white,
      child: Column(
        mainAxisSize: .min,
        children: [
          _buildTitleAboutAward("Топгемы".toUpperCase(), image: "assets/top-gem.png"),
          _buildAboutAward(
            """
Получение топгемов предусмотрено за:

1) Сдачу домашнего задания и лабораторной работы
2) Работу в классе
3) Сдачу контрольных и итоговых тестов
4) Контрольную работу
5) Сдачу экзамена и курсовой работы
За открытые (непросроченные) задания топгемы начисляются по схеме:

+5 - за 12 баллов
+4 - за 11 баллов
+3 - за 10 баллов
+2 - за 9 баллов
+1 - за 8 баллов
За оценки ниже 7 баллов топгемы не начисляются.
Дополнительно топгемы можно заработать

+1 - за лабораторную работу
+1 - за выполненное просроченное домашнее задание
+5 - за размещенную работу в разделе «Портфолио» (только для студентов, которые проходят обучение по направлению дизайна)
За сдачу экзамена или курсовой работы количество полученных топгемов умножается на х3.

Таким образом, если оценка от 12 до 8 баллов, то можно получить:

5 х 3 = 15
4 х 3 = 12
3 х 3 = 9
2 х 3 = 6
1 х 3 = 3
"""
          ),
        ],
      ),
    );
  }

  Widget _buildContainerAboutAwardCoin() {
    return Container(
      padding: EdgeInsets.all(33),
      color: Colors.white,
      child: Column(
        mainAxisSize: .min,
        children: [
          _buildTitleAboutAward("Топкоины".toUpperCase(), image: "assets/top-coin.png"),
          _buildAboutAward(
            """
Топкоины - это показатель вашей активности в академии, они начисляются за:

1) Посещение пары
2) Своевременную сдачу домашней или лабораторной работы
3) Поощрение от преподавателя за работу на уроке
4) Посещение академии 5, 10, 20 раз подряд без пропусков
(Получение данной награды выполняется единоразово)
5) Посещение академии 5, 10, 20 раз подряд без опозданий
(Получение данной награды выполняется единоразово)
6) Участие в конкурсе
7) Публикация отзыва в официальных группах академии в социальных сетях. Ссылки на официальные группы в социальных сетях для написания отзывов уточните у менеджера учебного процесса либо на сайте академии.
8) Привел друга учиться в TOP
9) Полностью заполненный профиль в Journalе: контакты, телефоны, ссылки на соц. сети
10) Посещение академии в футболке с логотипом «TOP»
11) Участие в опросе
Топкоины начисляются по схеме:

+1 - Своевременная сдача домашней или лабораторной работы. Топкоин за просроченное задание не выдается.
+1 - за посещение урока
+1 - 5 посещений подряд без пропусков - студент получает 1 топкоин в случае если 5 учебных дней подряд студент посещал занятия без пропусков.
После получения награды счетчик посещенных занятий без пропусков обнуляется.
+2 - 10 посещений подряд без пропусков - студент получает 2 топкоина и 1 награду в случае если 10 учебных дней подряд студент посещал занятия без пропусков.
После получения награды счетчик посещенных занятий без пропусков обнуляется.
+5 - 20 посещений подряд без пропусков - студент получает 5 топкоинов в случае если 20 учебных дней подряд студент посещал занятия без пропусков.
После получения награды счетчик посещенных занятий без пропусков обнуляется.
+1 - 5 посещений подряд без опозданий - студент получает 1 топкоин в случае если 5 учебных дней подряд студент посещал занятия без опозданий.
После получения награды счетчик посещенных занятий без опозданий обнуляется.
+2 - 10 посещений подряд без опозданий - студент получает 2 топкоина и 1 награду в случае если 10 учебных дней подряд студент посещал занятия без опозданий.
После получения награды счетчик посещенных занятий без опозданий обнуляется.
+3 - 20 посещений подряд без опозданий - студент получает 5 топкоинов в случае если 20 учебных дней подряд студент посещал занятия без опозданий.
После получения награды счетчик посещенных занятий без опозданий обнуляется.
От 1 до 5 - Поощрение от преподавателя за работу на уроке (на усмотрение преподавателя)
+20 - Публикация отзывов в официальных группах академии в социальных сетях
+1 - за размещение работы в «Портфолио» (только для студентов которые проходят обучение по направлению дизайн)
+1 - Посещение академии в футболке с логотипом «TOP»
+5 - Полностью заполненный профиль в Journalе: контакты, телефоны, ссылки на соц. сети
+10 - Привел друга учиться в «TOP»
+20 - За участие в опросе
От 1 до 100 - Участие в конкурсе (на усмотрение организатора)
"""
          ),
        ],
      ),
    );
  }

  Widget _buildContainerAboutAwardAchievements() {
    return Container(
      padding: EdgeInsets.all(33),
      color: Colors.white,
      child: Column(
        mainAxisSize: .min,
        children: [
          _buildTitleAboutAward("Достижения".toUpperCase()),
          _buildAboutAward(
            """
Представляют собой награды, которые вы можете получить только один раз. Не влияют на баллы или рейтинг.

Достижения можно получить за:

1) 5 посещений без пропусков
2) 10 посещений без пропусков
3) 20 посещений без пропусков
4) 5 посещений без опозданий
5) 10 посещений без опозданий
6) 20 посещений без опозданий
7) Участие в конкурсе
8) Публикация отзыва в официальных группах академии в социальных сетях
9) Привел друга учиться в «TOP»
10) Полностью заполненный профиль в Journalе: контакты, телефоны, ссылки на соц. сети
11) Посещение академии в футболке с логотипом «TOP»
12) Участие в опросе
"""
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAboutAward(String title, {String? image}) {
    return Row(
      spacing: 8,
      mainAxisAlignment: .center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
        ),
        if (image != null)
        Image.asset(
          width: 25,
          image,
        )
      ],
    );
  }

  Widget _buildAboutAward(String subTitle) {
    return Flexible(
      child: Text(
        subTitle,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  } 
}