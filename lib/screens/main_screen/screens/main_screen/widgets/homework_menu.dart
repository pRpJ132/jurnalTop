import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';

class HomeworkMenu extends StatefulWidget {
  const HomeworkMenu({super.key});

  @override
  State<HomeworkMenu> createState() => _HomeworkMenuState();
}

class _HomeworkMenuState extends State<HomeworkMenu> {
  final homeworkConfirm = ValueNotifier<int>(0);
  final homeworkCurrent = ValueNotifier<int>(0);
  final homeworkUnderReview = ValueNotifier<int>(0);
  final homeworkExpired = ValueNotifier<int>(0);
  final homeworkAll = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  @override
  void dispose() {
    homeworkConfirm.dispose();
    homeworkCurrent.dispose();
    homeworkUnderReview.dispose();
    homeworkExpired.dispose();
    homeworkAll.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(6),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                "Домашние задание",
                style: TextStyle(color: Colors.black, fontSize: 21),
              ),
            ),
            Divider(),
            Center(
              child: ValueListenableBuilder<int>(
                valueListenable: homeworkAll,
                builder: (_, value, _) => Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 47,
                    color: Color(0xFF188194),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "Все задания",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  padding: EdgeInsets.all(24),
                  color: Color(0xFFf5f8fa),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 18,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: homeworkCurrent,
                        builder: (_, value, _) =>
                            widgetTextRow(value.toString(), "Текущие", color: Colors.deepPurple),
                      ),

                      ValueListenableBuilder<int>(
                        valueListenable: homeworkConfirm,
                        builder: (_, value, _) =>
                            widgetTextRow(value.toString(), "Проверено", color: Color(0xFF188194)),
                      ),

                      ValueListenableBuilder<int>(
                        valueListenable: homeworkUnderReview,
                        builder: (_, value, _) =>
                            widgetTextRow(value.toString(), "На проверке",
                                color: Color.fromARGB(255, 237, 216, 27)),
                      ),

                      ValueListenableBuilder<int>(
                        valueListenable: homeworkExpired,
                        builder: (_, value, _) =>
                            widgetTextRow(value.toString(), "Просрочено", color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadHomework() async {
    final response = await ApiClient.get("count/homework");
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      homeworkConfirm.value = data[0]["counter"].toInt();
      homeworkCurrent.value = data[1]["counter"].toInt();
      homeworkExpired.value = data[2]["counter"].toInt();
      homeworkUnderReview.value = data[3]["counter"].toInt();
      homeworkAll.value = data[5]["counter"].toInt();
    }
  }

}

Widget widgetTextRow(
  String count,
  String text, {
  Color color = Colors.black,
}) {
  return SizedBox(
    width: 200,
    child: Row(
      children: [
        Text(
          count,
          style: TextStyle(color: color, fontSize: 18),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}
