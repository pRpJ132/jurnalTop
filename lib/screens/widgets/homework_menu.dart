import 'package:flutter/material.dart';

class HomeworkMenu extends StatelessWidget {
  const HomeworkMenu({super.key});

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
                "121",
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
                      widgetTextRow('0', "Текущие", color: Colors.deepPurple),
                      widgetTextRow('109', "Проверено", color: Color(0xFF188194)),
                      widgetTextRow('10', "На проверке", color: Color.fromARGB(255, 237, 216, 27)),
                      widgetTextRow('2', "Просрочено", color: Colors.red),
                    ],
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     widgetTextRow('0', "Текущие", color: Colors.deepPurple),
                  //     widgetTextRow('109', "Проверено", color: Color(0xFF188194)),
                  //     widgetTextRow('10', "На проверке", color: Color.fromARGB(255, 237, 216, 27)),
                  //     widgetTextRow('2', "Просрочено", color: Colors.red),
                  //   ],
                  // )
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
