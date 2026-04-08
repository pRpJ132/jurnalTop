import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/homework.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/services/user_storage.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _SpacesItem {
    String name;
    int specId;

    _SpacesItem({
      required this.name, 
      required this.specId
    });
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final _SpacesItem _basicItem = _SpacesItem(name: "Все", specId: -1);
  late ValueNotifier<List<_SpacesItem>> nameSpaces = ValueNotifier([_basicItem]);
  late ValueNotifier<_SpacesItem> selectedItem = ValueNotifier(_basicItem);

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  ValueNotifier<int> typeSpace = ValueNotifier(0);

  final Map<int, List<HomeworkItem>> homeworkByStatus = {
    0: [],
    1: [],
    2: [],
    3: [],
  };
  final Map<int, int> homeworkCounts = {};
  final Map<int, bool> _collapsed = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() async {
    _isLoading.value = true;
    await _loadSpecs();
    await _loadHomework();
    await _loadCounts();
    _isLoading.value = false;
  }

  Future<void> _loadHomework() async {
    final groupId = await UserStorage.getGroupId();
    for (var status in [0, 1, 2, 3]) {
      String strResp = "homework/operations/list?page=1&status=$status&type=${typeSpace.value}&group_id=$groupId";
      if (selectedItem.value.name != "Все") {
        strResp += "&spec_id=${selectedItem.value.specId}";
      }
      final response = await ApiClient.get(strResp);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        homeworkByStatus[status] = data.map<HomeworkItem>((el) => HomeworkItem.fromJson(el)).toList();
        setState(() => homeworkByStatus);
      }
    }
  }

  Future<void> _loadSpecs() async {
    final response = await ApiClient.get(
      "settings/group-specs",
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      nameSpaces.value = [_basicItem, ...data
        .map<_SpacesItem>((el) => _SpacesItem(
              name: el['name'],
              specId: el['id'],
            ))];
    }
  }

  Future<void> _loadCounts() async {
    final groupId = await UserStorage.getGroupId();
    String strResp = "count/homework?type=${typeSpace.value}&group_id=$groupId";
    if (selectedItem.value.name != "Все") {
      strResp += "&spec_id=${selectedItem.value.specId}";
    }
    final response = await ApiClient.get(strResp);
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
      case 0:
        return const Color.fromARGB(255, 211, 47, 47);
      case 1:
        return const Color.fromARGB(255, 46, 125, 50);
      case 2:
        return const Color.fromARGB(255, 218, 197, 14);
      case 3:
        return const Color.fromARGB(255, 21, 101, 192);
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return "Просрочено";
      case 1:
        return "Проверено";
      case 2:
        return "На проверке";
      case 3:
        return "Текущее";
      default:
        return "";
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.cancel_outlined;
      case 1:
        return Icons.check_circle_outline;
      case 2:
        return Icons.hourglass_top_outlined;
      case 3:
        return Icons.assignment_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _buildStatusHeader(int status) {
    final count = homeworkCounts[status] ?? homeworkByStatus[status]!.length;
    final color = _getStatusColor(status);
    final isCollapsed = _collapsed[status] ?? false;

    return GestureDetector(
      onTap: () => setState(() => _collapsed[status] = !isCollapsed),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 198, 195, 195)),
        ),
        child: Row(
          children: [
            Icon(_getStatusIcon(status), color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getStatusText(status),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: isCollapsed ? 0 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down, color: Color.fromARGB(255, 103, 98, 98), size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkItem(HomeworkItem e) {
    final status = e.status;
    final color = _getStatusColor(status);
    final mark = e.homeworkStud?.mark;

    return GestureDetector(
      onTap: () => _showDetail(e),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4), width: 1.2),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.nameSpec,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          if (mark != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.amber.shade300, width: 1),
                              ),
                              child: Text(
                                "★ $mark",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber.shade500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.theme,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd.MM.yyyy')
                                .format(e.completionTime ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            e.fioTeach,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      if (e.homeworkStud != null && status != 0) ...[
                        Row(
                          children: [
                            Icon(Icons.check,
                                size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd.MM.yyyy')
                                  .format(e.homeworkStud?.creationTime ?? DateTime.now()),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ] else if (status == 0) ...[
                        Text(
                          "Истекший",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.chevron_right,
                    size: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(int status) {
    final list = homeworkByStatus[status] ?? [];
    if (list.isEmpty) return const SizedBox();
    final isCollapsed = _collapsed[status] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStatusHeader(status),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              ...list.map(_buildHomeworkItem),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: const Color.fromARGB(255, 30, 121, 163),
                  elevation: 0
                ),
                onPressed: () {},
                child: Text(
                  "Показать еще",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 26, 159, 243)
                  ),
                ),
              ),
            ],
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isCollapsed
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          sizeCurve: Curves.easeInOut,
          firstCurve: Curves.easeInBack,
          secondCurve: Curves.easeInBack,
          duration: const Duration(milliseconds: 350),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildTabBody() {
    final statuses = [3, 2, 1, 0];

    final hasAny = statuses.any((s) => homeworkByStatus[s]!.isNotEmpty);
    if (!hasAny) return _buildEmpty();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.map(_buildSection).toList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined, size: 52, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            "Нет заданий",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _showDetail(HomeworkItem e) {
    final status = e.status;
    final color = _getStatusColor(status);
    final stud = e.homeworkStud;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 6),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getStatusIcon(status),
                            color: color, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          _getStatusText(status),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                      children: [
                        Text(
                          e.nameSpec,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e.theme,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Divider(height: 28),

                        _detailRow(
                          Icons.person_outline,
                          Colors.grey,
                          "Преподаватель",
                          e.fioTeach,
                        ),
                        const SizedBox(height: 12),
                        _detailRow(
                          Icons.calendar_today_outlined,
                          Colors.grey,
                          "Срок сдачи",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.completionTime ?? DateTime.now()),
                        ),
                        const SizedBox(height: 12),
                        _detailRow(
                          Icons.add_circle_outline,
                          Colors.lightBlueAccent,
                          "Дата создания",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.creationTime ?? DateTime.now()),
                        ),
                        const SizedBox(height: 12),
                        _detailRow(
                          Icons.warning_amber_outlined,
                          Colors.red,
                          "Дедлайн",
                          DateFormat('dd MMMM yyyy', 'ru').format(e.overdueTime ?? DateTime.now()),
                        ),
                        if (e.homeworkStud != null && status != 0) ...[
                          const SizedBox(height: 12),
                          _detailRow(
                            Icons.check,
                            Colors.green,
                            "Сдано",
                            DateFormat('dd MMMM yyyy', 'ru').format(e.homeworkStud?.creationTime ?? DateTime.now()),
                          ),
                        ] else if (status == 0) ...[
                          const SizedBox(height: 12),
                          Text(
                            "Истекший",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          )
                        ],

                        if (stud != null) ...[
                          const Divider(height: 28),
                          const Text(
                            "Ваш ответ",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (stud.mark != null)
                            _detailRow(
                              Icons.star,
                              Colors.amber.shade500,
                              "Оценка",
                              "${stud.mark}",
                              valueColor: Colors.amber.shade500,
                            ),
                          if (stud.studAnswer != null && stud.studAnswer!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            _detailRow(
                              Icons.text_snippet_outlined,
                              Colors.grey,
                              "Текст ответа",
                              stud.studAnswer ?? "-",
                            ),
                          ],
                          if (stud.filePath != null) ...[
                            const SizedBox(height: 10),
                            _detailRow(
                              Icons.attach_file,
                              Colors.grey,
                              "Файл ответа",
                              "Прикреплён",
                              valueColor: Colors.blue.shade700,
                            ),
                          ],
                        ],

                        if (e.homeworkComment != null && e.homeworkComment?.textComment != null && e.homeworkComment!.textComment!.isNotEmpty) ...[
                          const Divider(height: 28),
                          const Text(
                            "Комментарий преподавателя",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.blue.shade100),
                            ),
                            child: SelectableText(
                              e.homeworkComment?.textComment ?? "-",
                              style:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],

                        if (e.comment.isNotEmpty) ...[
                          const Divider(height: 28),
                          const Text(
                            "Примечание к заданию",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.orange.shade100),
                            ),
                            child: SelectableText(
                              e.comment,
                              style:
                                  const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(IconData icon, Color colorIcon, String label, String value,
      {Color valueColor = Colors.black87}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: colorIcon),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (_, isLoadingValue, _) {
          if (isLoadingValue == true) {
            return Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 10),
                  child: const Text(
                    "ДОМАШНИЕ ЗАДАНИЯ",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: nameSpaces,
                      builder: (_, spacesVal, _) => ValueListenableBuilder(
                        valueListenable: selectedItem,
                        builder: (_, selectedValue, _) {
                          return PopupMenuButton<_SpacesItem>(
                            initialValue: selectedValue,
                            onSelected: (_SpacesItem item) {
                              selectedItem.value = item;
                              _loadAll();
                            },
                            constraints: BoxConstraints(
                              maxHeight: 450,
                              maxWidth: 250
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.white,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                              constraints: BoxConstraints(
                                maxWidth: 200.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(16)
                              ),
                              child: Text(
                                selectedValue.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            itemBuilder: (BuildContext context) {
                              return spacesVal.map((el) {
                                return PopupMenuItem<_SpacesItem>(
                                  value: el,
                                  child: Text(el.name),
                                );
                              }).toList();
                            },
                          );
                        }
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: typeSpace,
                      builder: (_, typeSpaceValue, _) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            overlayColor: Colors.white
                          ),
                          onPressed: ()  {
                            typeSpace.value == 0 ? typeSpace.value = 1 : typeSpace.value = 0;
                            _loadAll();
                          }, 
                          child: Text(
                            typeSpaceValue == 0 ? "Лабораторные работы" : "Домашние задания",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          )
                        );
                      }
                    ),
                  ],
                ),
          
                SizedBox(height: 20),
            
                _buildTabBody(),
              ],
            ),
          );
        }
      ),
    );
  }
}