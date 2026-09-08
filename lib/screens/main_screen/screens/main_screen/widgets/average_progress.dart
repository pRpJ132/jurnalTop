import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AverageProgress extends StatefulWidget {
  const AverageProgress({super.key});

  @override
  State<AverageProgress> createState() => _AverageProgressState();
}

class _AverageProgressValue {
  final DateTime? date;
  final bool? hasRasp;
  final double points;
  final int? previousPoints;

  _AverageProgressValue({
    required this.date,
    required this.hasRasp,
    required this.points,
    required this.previousPoints,
  });
}

class _AverageProgressState extends State<AverageProgress> {
  static final _lisAttendance = ValueNotifier<List<_AverageProgressValue>>([]);

  @override
  void initState() {
    super.initState();
    _loadAttendance();
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
            "Оценки",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22
            ),
          ),
          SizedBox(height: 15),
          ValueListenableBuilder<List<_AverageProgressValue>>(
            valueListenable: _lisAttendance,
            builder: (_, data, _) {
              return Skeletonizer(
                enabled: data.isEmpty,
                child: SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            strokeWidth: 1,
                            color: Colors.grey.withValues(alpha: 0.3),
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
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                maxLines: 1,
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
                          
                      borderData: FlBorderData(
                        show: true,
                        border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.grey.withValues(alpha: 0.3), width: 1),
                        ),
                      ),
                          
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final index = spot.x.toInt();
                              final item = data[index];
                
                              return LineTooltipItem(
                                '${item.points.toInt() == 0 ? "-" : item.points.toInt()}',
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
                              item.points == 0 ? 0 : item.points,
                            );
                          }),
                          color: const Color.fromARGB(255, 225, 0, 0),
                          isCurved: false,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                          
                      minY: 0,
                      maxY: 5,
                    ),
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
    final response = await ApiClient.get("dashboard/chart/average-progress");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _lisAttendance.value = (data as List)
          .map<_AverageProgressValue>((el) => _AverageProgressValue(
                date: DateTime.tryParse(el['date']),
                hasRasp: el['has_rasp'],
                points: ((el['points'] as num?)?.clamp(0, 5) ?? 0).toDouble(),
                previousPoints: el['previous_points'],
              ))
          .toList();
    }
  }
}