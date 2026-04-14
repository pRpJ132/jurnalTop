import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/models/homework.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_color.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_icon.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/service/get_status_text.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/widgets/build_homework_item.dart';
import 'package:my_app/services/user_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  late final ValueNotifier<List<_SpacesItem>> nameSpaces = ValueNotifier([_basicItem]);
  late final ValueNotifier<_SpacesItem> selectedItem = ValueNotifier(_basicItem);

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  final ValueNotifier<int> _typeSpace = ValueNotifier(0);

  final ValueNotifier<bool> _isLoadingPage = ValueNotifier(false);


  static final Map<int, List<HomeworkItem>> _homeworkByStatus = {
    0: [],
    1: [],
    2: [],
    3: [],
  };
  Map<int, int> pageByStatus = {
    0: 1,
    1: 1,
    2: 1,
    3: 1,
  };
  static final ValueNotifier<Map<int, int>> _homeworkCounts = ValueNotifier({});
  final Map<int, bool> _collapsed = {
    0: true,
    1: true,
    2: true,
    3: false,
  };

  @override
  void dispose() {
    nameSpaces.dispose();
    selectedItem.dispose();
    _isLoading.dispose();
    _typeSpace.dispose();
    _isLoadingPage.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _homeworkByStatus;
    _loadAll();
  }

  void _loadAll() async {
    _isLoading.value = true;
    _loadSpecs();
    await _loadHomework();
    await _loadCounts();
    _isLoading.value = false;
  }

  Future<void> _loadHomework() async {
    final groupId = await UserStorage.getGroupId();
    for (var status in [0, 1, 2, 3]) {
      String strResp = "homework/operations/list?page=${pageByStatus[status]}&status=$status&type=${_typeSpace.value}&group_id=$groupId";
      if (selectedItem.value.name != "Все") {
        strResp += "&spec_id=${selectedItem.value.specId}";
      }
      final response = await ApiClient.get(strResp);
      if (response.statusCode == 200) {
        pageByStatus[status] = pageByStatus[status] !+ 1;
        final data = jsonDecode(response.body);
        _homeworkByStatus[status] = data.map<HomeworkItem>((el) => HomeworkItem.fromJson(el)).toList();
        setState(() => _homeworkByStatus);
      }
    }
  }

  Future<void> loadPageHomework(int status) async {
    final groupId = await UserStorage.getGroupId();
    String strResp = "homework/operations/list?page=${pageByStatus[status]}&status=$status&type=${_typeSpace.value}&group_id=$groupId";
    if (selectedItem.value.name != "Все") {
      strResp += "&spec_id=${selectedItem.value.specId}";
    }
    final response = await ApiClient.get(strResp);
    if (response.statusCode == 200) {
      pageByStatus[status] = pageByStatus[status] !+ 1;
      final data = jsonDecode(response.body);
      _homeworkByStatus[status]?.addAll(data.map<HomeworkItem>((el) => HomeworkItem.fromJson(el)).toList());
      setState(() => _homeworkByStatus);
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
    String strResp = "count/homework?type=${_typeSpace.value}&group_id=$groupId";
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
      _homeworkCounts.value = {};
      _homeworkCounts.value = temp;
    }
  }

  Widget _buildStatusHeader(int status) {
    final color = getStatusColor(status);
    final isCollapsed = _collapsed[status] ?? false;

    return ValueListenableBuilder(
      valueListenable: _homeworkCounts,
      builder: (_, homeworkCountsValue, _) {
        final count = homeworkCountsValue[status] ?? _homeworkByStatus[status]!.length;
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
                Icon(getStatusIcon(status), color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    getStatusText(status),
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
    );
  }

  Widget _buildSection(int status) {
    final list = _homeworkByStatus[status] ?? [];
    if (list.isEmpty) return const SizedBox();
    final isCollapsed = _collapsed[status] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildStatusHeader(status),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              ...list.map((el) => buildHomeworkItem(context, el)),
              if (list.length < (_homeworkCounts.value[status] ?? 0))
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: const Color.fromARGB(255, 30, 121, 163),
                  elevation: 0
                ),
                onPressed: () async {
                  if (_isLoadingPage.value) return;
                  _isLoadingPage.value = true;
                  await loadPageHomework(status);
                  _isLoadingPage.value = false;
                },
                child: ValueListenableBuilder(
                  valueListenable: _isLoadingPage,
                  builder: (_, isLoadingPageValue, _) {
                    return !isLoadingPageValue ? Text(
                      "Показать еще",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 26, 159, 243)
                      ),
                    ) : CircularProgressIndicator();
                  }
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

    final hasAny = statuses.any((s) => _homeworkByStatus[s]!.isNotEmpty);
    if (!hasAny) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses.map(_buildSection).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (_, isLoadingValue, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 10),
                  child: Text(
                    "Домашние задания".toUpperCase(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
          
                Skeletonizer(
                  enabled: (isLoadingValue && _homeworkCounts.value.isEmpty),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: nameSpaces,
                        builder: (_, nameSpacesVal, _) => ValueListenableBuilder(
                          valueListenable: selectedItem,
                          builder: (_, selectedItemValue, _) {
                            return PopupMenuButton<int>(
                              popUpAnimationStyle: AnimationStyle(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.easeOut,
                                reverseCurve: Curves.easeIn,
                                reverseDuration: Duration(milliseconds: 100)
                              ),
                              initialValue: selectedItemValue.specId,
                              onSelected: (int specId) {
                                selectedItem.value = nameSpacesVal.firstWhere((el) => el.specId == specId);
                                pageByStatus = {
                                  0: 1,
                                  1: 1,
                                  2: 1,
                                  3: 1,
                                };
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
                                  selectedItemValue.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              itemBuilder: (BuildContext context) {
                                return nameSpacesVal.map((el) {
                                  return PopupMenuItem<int>(
                                    value: el.specId,
                                    child: Text(el.name),
                                  );
                                }).toList();
                              },
                            );
                          }
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _typeSpace,
                        builder: (_, typeSpaceValue, _) {
                          return Flexible(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                overlayColor: Colors.white
                              ),
                              onPressed: ()  {
                                _typeSpace.value == 0 ? _typeSpace.value = 1 : _typeSpace.value = 0;
                                pageByStatus = {
                                  0: 1,
                                  1: 1,
                                  2: 1,
                                  3: 1,
                                };
                                _loadAll();
                              }, 
                              child: Text(
                                typeSpaceValue == 0 ? "Лабораторные работы" : "Домашние задания",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              )
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
          
                SizedBox(height: 20),
            
                Skeletonizer(
                  enabled: (isLoadingValue && _homeworkCounts.value.isEmpty),
                  child: _buildTabBody()
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}