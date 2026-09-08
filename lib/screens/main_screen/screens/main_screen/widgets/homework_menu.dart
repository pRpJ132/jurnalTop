import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeworkMenu extends StatefulWidget {
  const HomeworkMenu({super.key});

  @override
  State<HomeworkMenu> createState() => _HomeworkMenuState();
}

class _HomeworkMenuState extends State<HomeworkMenu> {
  static final _homeworkConfirm = ValueNotifier<int?>(null);
  static final _homeworkCurrent = ValueNotifier<int?>(null);
  static final _homeworkUnderReview = ValueNotifier<int?>(null);
  static final _homeworkExpired = ValueNotifier<int?>(null);
  static final _homeworkAll = ValueNotifier<int?>(null);
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _loadHomework();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  bool isValueEmpty() {
    if (_homeworkConfirm.value == null || 
      _homeworkCurrent.value == null ||
      _homeworkUnderReview.value == null ||
      _homeworkExpired.value == null ||
      _homeworkAll.value == null ) {
      return true;
    }
    return false;
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
        child: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (_, isLoadingValue, _) {
            return Skeletonizer(
              enabled: (isLoadingValue && isValueEmpty()),
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
                    child: ValueListenableBuilder<int?>(
                      valueListenable: _homeworkAll,
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
                            ValueListenableBuilder<int?>(
                              valueListenable: _homeworkCurrent,
                              builder: (_, value, _) =>
                                  widgetTextRow(value.toString(), "Текущие", color: Colors.deepPurple),
                            ),
              
                            ValueListenableBuilder<int?>(
                              valueListenable: _homeworkConfirm,
                              builder: (_, value, _) =>
                                  widgetTextRow(value.toString(), "Проверено", color: Color(0xFF188194)),
                            ),
              
                            ValueListenableBuilder<int?>(
                              valueListenable: _homeworkUnderReview,
                              builder: (_, value, _) =>
                                  widgetTextRow(value.toString(), "На проверке",
                                      color: Color.fromARGB(255, 237, 216, 27)),
                            ),
              
                            ValueListenableBuilder<int?>(
                              valueListenable: _homeworkExpired,
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
            );
          }
        ),
      ),
    );
  }

  void _loadHomework() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get("count/homework");
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        _homeworkConfirm.value = data[0]["counter"].toInt();
        _homeworkCurrent.value = data[1]["counter"].toInt();
        _homeworkExpired.value = data[2]["counter"].toInt();
        _homeworkUnderReview.value = data[3]["counter"].toInt();
        _homeworkAll.value = data[5]["counter"].toInt();
      }
    } finally {
      _isLoading.value = false;
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
