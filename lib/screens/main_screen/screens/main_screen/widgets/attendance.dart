import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final lisAttendance = ValueNotifier<List<dynamic>>([]);

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ValueListenableBuilder<List<dynamic>>(
        valueListenable: lisAttendance,
        builder: (context, data, _) {
          if (data.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            width: double.infinity,
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(data.length, (index) {
                      final item = data[index];
                      return FlSpot(
                        index.toDouble(),
                        (item['points'] as num).toDouble(),
                      );
                    }),
                    isCurved: true,
                    barWidth: 3,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadAttendance() async {
    final response = await ApiClient.get("dashboard/chart/attendance");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      lisAttendance.value = data;
    }
  }
}