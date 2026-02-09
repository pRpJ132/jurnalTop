import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';

class HomeworkMenu extends StatefulWidget {
  const HomeworkMenu({super.key});

  @override
  State<HomeworkMenu> createState() => _HomeworkMenuState();
}

class _HomeworkMenuState extends State<HomeworkMenu> {
  int homeworkConfirm = 0;
  int homeworkCurrent = 0;
  int homeworkUnderReview = 0;
  int homeworkExpired = 0;
  int homeworkAll = 0;

  @override
  void initState() {
    super.initState();
    LoadHomework();
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
              child: Text(
                homeworkAll.toString(),
                style: TextStyle(
                  fontSize: 47,
                  color: Color(0xFF188194),
                  fontWeight: FontWeight.w500,
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
                      widgetTextRow(homeworkCurrent.toString(), "Текущие", color: Colors.deepPurple),
                      widgetTextRow(homeworkConfirm.toString(), "Проверено", color: Color(0xFF188194)),
                      widgetTextRow(homeworkUnderReview.toString(), "На проверке", color: Color.fromARGB(255, 237, 216, 27)),
                      widgetTextRow(homeworkExpired.toString(), "Просрочено", color: Colors.red),
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

  void LoadHomework() async {
    final response = await ApiClient.get("count/homework");
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      setState(() {
        homeworkConfirm = data[0]["counter"].toInt();
        homeworkCurrent = data[1]["counter"].toInt();
        homeworkExpired = data[2]["counter"].toInt();
        homeworkUnderReview = data[3]["counter"].toInt();
        homeworkAll = data[5]["counter"].toInt();
      });
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
