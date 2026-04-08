import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendancePoint {
  final DateTime? date;
  final bool? hasRasp;
  final int? points;
  final int? previousPoints;

  _AttendancePoint({
    required this.date,
    required this.hasRasp,
    required this.points,
    required this.previousPoints,
  });
}

class _AttendanceState extends State<Attendance> {
  final lisAttendance = ValueNotifier<List<_AttendancePoint>>([]);

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  @override
  void dispose() {
    lisAttendance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 34, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Посещаемость",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22
            ),
          ),
          SizedBox(height: 10),
          ValueListenableBuilder<List<_AttendancePoint>>(
            valueListenable: lisAttendance,
            builder: (_, data, _) {
              if (data.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
          
              return SizedBox(
                width: double.infinity,
                height: 250,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: 19.9,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          strokeWidth: 1,
                          color: Colors.grey.withOpacity(0.3),
                        );
                      },
                    ),
          
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
          
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            );
                          },
                        ),
                      ),
          
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.length) {
                              return const SizedBox();
                            }
          
                            final date = data[index].date;
          
                            if (date == null) return const SizedBox();
          
                            const months = [
                              'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
                              'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'
                            ];
          
                            return Text(months[date.month - 1]);
                          },
                        ),
                      ),
                    ),
          
                    borderData: FlBorderData(show: false),
          
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            final item = data[index];
          
                            return LineTooltipItem(
                              '${item.points}%',
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
          
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(data.length, (index) {
                          final item = data[index];
                          return FlSpot(
                            index.toDouble(),
                            item.points?.toDouble() ?? 0,
                          );
                        }),
                        color: const Color.fromARGB(255, 225, 0, 0),
                        isCurved: true,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
          
                    minY: 0,
                    maxY: 100,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _loadAttendance() async {
    final response = await ApiClient.get("dashboard/chart/attendance");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      lisAttendance.value = (data as List)
          .map<_AttendancePoint>((el) => _AttendancePoint(
                date: DateTime.tryParse(el['date']),
                hasRasp: el['has_rasp'],
                points: el['points'],
                previousPoints: el['previous_points'],
              ))
          .toList();
    }
  }
}