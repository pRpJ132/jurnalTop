import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/student_visits.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssessmentsScreen extends StatefulWidget {
  const AssessmentsScreen({super.key});

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  final ValueNotifier<List<StudentVisits>> _assessments = ValueNotifier([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadAssessments();
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading.dispose();
    _assessments.dispose();
  }

  Future<void> _loadAssessments() async {
    try {
      _isLoading.value = true;
      final response = await ApiClient.get(
        "progress/operations/student-visits"
      );

      if(response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _assessments.value = body.map<StudentVisits>((el) => StudentVisits.fromJson(el)).toList();
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Color _statusWasColorContainer(StudentVisits? assessments) {
    switch (assessments?.statusWas) {
      case 0:
        return const Color.fromARGB(142, 255, 17, 0);
      case 2:
        return const Color.fromARGB(142, 255, 251, 0);
    }
    return const Color.fromARGB(120, 216, 224, 228);
  }

  Color _statusWasColorItem(StudentVisits assessments) {
    switch (assessments.statusWas) {
      case 0:
        return const Color.fromARGB(203, 255, 17, 0);
      case 2:
        return const Color.fromARGB(255, 210, 206, 0);
    }
    return const Color.fromARGB(255, 80, 80, 80);
  }

  Color _statusWasColorText(StudentVisits? assessments) {
    switch (assessments?.statusWas) {
      case 0:
        return Colors.black;
      case 2:
        return Colors.black;
    }
    return Colors.black;
  }

  Widget _markCircle(Color color, int mark) {
    return Container(
      width: 14,
      height: 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        "$mark",
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _nameWorkColor(String workName) {
    switch(workName) {
      case "controlWorkMark":
        return Color.fromARGB(255, 123, 201, 126);
      case "homeWorkMark":
        return Color.fromARGB(255, 217, 15, 0);
      case "labWorkMark":
        return Color.fromARGB(255, 205, 126, 219);
      case "classWorkMark":
        return Color.fromARGB(255, 23, 107, 175);
      case "practicalWorkMark":
        return Color.fromARGB(255, 255, 174, 53);
      case "finalWorkMark":
        return Color.fromARGB(255, 168, 168, 168);
    }

    return Color.fromARGB(255, 168, 168, 168);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 9.0, top: 14),
              child: Text(
                "Оценки".toUpperCase(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Flexible(
              child: ValueListenableBuilder(
                valueListenable: _isLoading,
                builder: (_, isLoadingValue, _) {
                  if (isLoadingValue) {
                    return Skeletonizer(
                      enabled: isLoadingValue, 
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: 67,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 600 
                            ? MediaQuery.of(context).size.width < 400 
                              ? 4 : 5 
                                : 10,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (_, _) => Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _statusWasColorContainer(null),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    DateFormat('dd.MM.yyyy').format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _statusWasColorText(null),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "657",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: _statusWasColorText(null),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              
                              Flexible(
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("controlWorkMark"), Random().nextInt(5) + 1),
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("homeWorkMark"), Random().nextInt(5) + 1),
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("labWorkMark"), Random().nextInt(5) + 1),
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("classWorkMark"), Random().nextInt(5) + 1),
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("practicalWorkMark"), Random().nextInt(5) + 1),
                                    if(Random().nextInt(5) + 1 > 3)
                                      _markCircle(_nameWorkColor("finalWorkMark"), Random().nextInt(5) + 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    );
                  }

                  return ValueListenableBuilder(
                    valueListenable: _assessments,
                    builder: (_, assessmentsValue, _) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: assessmentsValue.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 600 
                            ? MediaQuery.of(context).size.width < 400 
                              ? 4 : 5 
                                : 10,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (_, index) {
                          final item = assessmentsValue[index];
                          
                          return GestureDetector(
                            onTap: () => _showDetail(item),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _statusWasColorContainer(item),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(item.dateVisit),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _statusWasColorText(item),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${assessmentsValue.length - 1 - index + 1}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: _statusWasColorText(item),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  Flexible(
                                    child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      alignment: WrapAlignment.center,
                                      children: [
                                        if(item.controlWorkMark != null)
                                          _markCircle(_nameWorkColor("controlWorkMark"), item.controlWorkMark ?? -1),
                                        if(item.homeWorkMark != null)
                                          _markCircle(_nameWorkColor("homeWorkMark"), item.homeWorkMark ?? -1),
                                        if(item.labWorkMark != null)
                                          _markCircle(_nameWorkColor("labWorkMark"), item.labWorkMark ?? -1),
                                        if(item.classWorkMark != null)
                                          _markCircle(_nameWorkColor("classWorkMark"), item.classWorkMark ?? -1),
                                        if(item.practicalWorkMark != null)
                                          _markCircle(_nameWorkColor("practicalWorkMark"), item.practicalWorkMark ?? -1),
                                        if(item.finalWorkMark != null)
                                          _markCircle(_nameWorkColor("finalWorkMark"), item.finalWorkMark ?? -1),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(StudentVisits e) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Text(
                  "Детали посещения",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _item("Дата посещения", DateFormat('dd.MM.yyyy').format(e.dateVisit)),
                _item("Статус", 
                  e.statusWas == 0 ? "Пропуск" 
                    : e.statusWas == 1 ? "Присутствовал" 
                      : "Опоздал",
                  textColor: _statusWasColorItem(e)),
                _item("Пара", e.lessonNumber?.toString() ?? "-"),
                _item("Преподаватель", e.teacherName),
                _item("Специальность", e.specName),
                _item("Тема урока", e.lessonTheme),

                const SizedBox(height: 12),

                Text(
                  "Оценки",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                _item("Контрольная", e.controlWorkMark?.toString() ?? "-", textColor: _nameWorkColor("controlWorkMark")),
                _item("Домашняя работа", e.homeWorkMark?.toString() ?? "-", textColor: _nameWorkColor("homeWorkMark")),
                _item("Лабораторная", e.labWorkMark?.toString() ?? "-", textColor: _nameWorkColor("labWorkMark")),
                _item("Классная работа", e.classWorkMark?.toString() ?? "-", textColor: _nameWorkColor("classWorkMark")),
                _item("Практическая", e.practicalWorkMark?.toString() ?? "-", textColor: _nameWorkColor("practicalWorkMark")),
                _item("Итоговая", e.finalWorkMark?.toString() ?? "-", textColor: _nameWorkColor("finalWorkMark")),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _item(
    String title, 
    String value,
    {Color? textColor}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.black
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: textColor ?? Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}