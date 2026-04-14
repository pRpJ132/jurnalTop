import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final _schedules = ValueNotifier<List<dynamic>>([]);
  final Map<String, List<dynamic>> _cache = {};

  final _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  @override
  void dispose() {
    _schedules.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> _loadSchedules() async {
    try {
      _isLoading.value = true;
      final dateFilter = DateFormat('yyyy-MM-dd').format(_currentMonth);

      final cacheKey = DateFormat('yyyy-MM').format(_currentMonth);

      if (_cache.containsKey(cacheKey)) {
        _schedules.value = _cache[cacheKey]!;
        return;
      }

      final response = await ApiClient.get(
        "schedule/operations/get-month?date_filter=$dateFilter",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _cache[cacheKey] = data;

        _schedules.value = data;
      }
    } finally {
      _isLoading.value = false;
    }
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
    _loadSchedules();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
    _loadSchedules();
  }

  List<DateTime?> _generateDays() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);

    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    int startOffset = firstDayOfMonth.weekday - 1;

    List<DateTime?> days = [];

    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }

    for (int i = 0; i < lastDayOfMonth.day; i++) {
      days.add(DateTime(
        _currentMonth.year,
        _currentMonth.month,
        i + 1,
      ));
    }

    return days;
  }

  bool? _hasLesson(DateTime? day) {
    if (day == null) {
      return null;
    }
    final dateStr = DateFormat('yyyy-MM-dd').format(day);

    return _schedules.value.any((e) => e['date'] == dateStr);
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9)
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Расписание".toUpperCase(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _prevMonth,
                  icon: Icon(
                    Icons.chevron_left,
                    size: MediaQuery.of(context).size.width < 600 ? 25 : 45,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy', 'ru').format(_currentMonth),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: Icon(
                    Icons.chevron_right, 
                    size: MediaQuery.of(context).size.width < 600 ? 25 : 45,
                  ),
                ),
              ],
            ),
              
            const SizedBox(height: 10),
              
            GridView(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              children: const [
                _WeekDay("ПН"),
                _WeekDay("ВТ"),
                _WeekDay("СР"),
                _WeekDay("ЧТ"),
                _WeekDay("ПТ"),
                _WeekDay("СБ"),
                _WeekDay("ВС"),
              ],
            ),
              
            ValueListenableBuilder(
              valueListenable: _isLoading,
              builder: (_, isLoadingValue, _) {
                return Skeletonizer(
                  enabled: isLoadingValue,
                  child: ValueListenableBuilder<List<dynamic>>(
                    valueListenable: _schedules,
                    builder: (_, value, _) => GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: days.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final day = days[index];
                        final hasLesson = _hasLesson(day);
                    
                        return GestureDetector(
                          onTap: () => _showDayDialog(day),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: hasLesson == null ? Colors.transparent : hasLesson
                                  ? const Color(0xFF188194)
                                  : const Color(0xFF9ac9c0),
                              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width < 600 ? 6 : 12),
                              border: Border.all(
                                color: hasLesson == null ? const Color.fromARGB(159, 154, 201, 192) : Colors.transparent
                              )
                            ),
                            child: Center(
                              child: Text(
                                "${day?.day ?? " "}",
                                style: TextStyle(
                                  color: (hasLesson != null && hasLesson) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 22,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  void _showDayDialog(DateTime? day) {
    if (day == null) {
      return;
    }
    final dateStr = DateFormat('yyyy-MM-dd').format(day);

    final dayLessons = _schedules.value.where((e) => e['date'] == dateStr).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            DateFormat('dd MMMM yyyy', 'ru').format(day),
          ),
          content: dayLessons.isEmpty
              ? const Text("Занятий нет")
              : SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dayLessons.length,
                      itemBuilder: (context, index) {
                        final lesson = dayLessons[index];
                    
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Пара ${lesson['lesson']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${lesson['started_at']} - ${lesson['finished_at']}",
                              ),
                              const SizedBox(height: 4),
                              Text(lesson['subject_name']),
                              const SizedBox(height: 4),
                              Text("Преподаватель: ${lesson['teacher_name']}"),
                              Text("Аудитория: ${lesson['room_name']}"),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                overlayColor: Colors.grey
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Закрыть",
                style: TextStyle(
                  color: Color.fromARGB(255, 43, 43, 43)
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _WeekDay extends StatelessWidget {
  final String text;

  const _WeekDay(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF188194),
        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width < 600 ? 6 : 12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 22,
          ),
        ),
      ),
    );
  }
}