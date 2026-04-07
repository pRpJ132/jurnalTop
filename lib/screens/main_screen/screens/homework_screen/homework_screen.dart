import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/services/user_storage.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final Map<int, List<dynamic>> homeworkByStatus = {
    0: [],
    1: [],
    2: [],
    3: [],
  };
  final Map<int, int> homeworkCounts = {};

  @override
  void initState() {
    super.initState();
    _loadHomework();
    _loadCounts();
  }

  Future<void> _loadHomework() async {
    List<int> statuses = [0, 1, 2, 3];
    final groupId = await UserStorage.getGroupId();

    for (var status in statuses) {
      final response = await ApiClient.get(
        "homework/operations/list?page=1&status=$status&type=0&group_id=$groupId",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          homeworkByStatus[status] = data;
        });
      }
    }
  }

  Future<void> _loadCounts() async {
    final groupId = await UserStorage.getGroupId();

    final response = await ApiClient.get(
      "count/homework?type=0&group_id=$groupId",
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      Map<int, int> temp = {};

      for (var item in data) {
        temp[item['counter_type']] = item['counter'];
      }

      setState(() {
        homeworkCounts.clear();
        homeworkCounts.addAll(temp);
      });
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0: return Colors.red.shade700;
      case 1: return Colors.green.shade700;
      case 2: return Colors.orange.shade700;
      case 3: return Colors.blue.shade700;
      default: return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0: return "Просрочено";
      case 1: return "Проверено";
      case 2: return "На проверке";
      case 3: return "Текущее";
      default: return "";
    }
  }

  Widget _buildStatusHeader(int status) {
    final count = homeworkCounts[status] ?? 0;
    final color = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getStatusText(status),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            "$count",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkItem(dynamic e) {
    final color = _getStatusColor(e['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Text(
                  e['name_spec'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),

              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

              if ((e['comment'] != null && e['comment'].isNotEmpty)) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _showComment(e['comment']),
                  child: const Icon(Icons.info_outline, size: 18),
                ),
              ]
            ],
          ),

          const SizedBox(height: 4),

          Text(
            e['theme'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),

          const SizedBox(height: 4),

          Text(
            DateFormat('dd.MM.yyyy')
                .format(DateTime.parse(e['completion_time'])),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int status) {
    final list = homeworkByStatus[status] ?? [];

    if (list.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusHeader(status),
        ...list.map(_buildHomeworkItem),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ДОМАШНИЕ ЗАДАНИЯ",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            _buildSection(3),
            _buildSection(2),
            _buildSection(1),
            _buildSection(0),
          ],
        ),
      ),
    );
  }

  void _showComment(String comment) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Комментарий"),
        content: SelectableText(comment),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Закрыть"),
          )
        ],
      ),
    );
  }
}