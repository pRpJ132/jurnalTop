
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/services/user_storage.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> 
  with SingleTickerProviderStateMixin {

  late TabController _controller;

  final listGroup = ValueNotifier<List<dynamic>>([]);
  final listStream = ValueNotifier<List<dynamic>>([]);
  int meUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadReitingInfo();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    listGroup.dispose();
    listStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    "Таблица лидеров", 
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                ),
                TabBar(
                  controller: _controller,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'Группа'),
                    Tab(text: 'Поток'),
                  ],
                )
              ],
            ),
            Divider(),
            SizedBox(
              height: 450,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: TabBarView(
                  controller: _controller,
                  children: [
                    ValueListenableBuilder<List<dynamic>>(
                      valueListenable: listGroup,
                      builder: (_, value, _) => SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: value.length,
                          itemBuilder: (_, index) { 
                            return _buildBoardGroup(value, index);
                          }
                        ),
                      )
                    ),
                    ValueListenableBuilder<List<dynamic>>(
                      valueListenable: listStream,
                      builder: (_, value, _) => SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: value.length,
                          itemBuilder: (_, index) { 
                            return _buildBoardStream(value, index);
                          }
                        ),
                      )
                    ),
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardStream(dynamic value, int index) {
    if (index == 3) {
      return Divider();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "${value[index]['position']}. ${value[index]?["full_name"] ?? "-"}",
            style: TextStyle(
              fontSize: 20,
              color: (value[index]?['id'] ?? -1) != meUserId ? Colors.black : const Color.fromARGB(255, 68, 193, 255)
            ),
          ),
        ),
        SizedBox(width: 15),
        Row(
          children: [
            Image.asset('assets/top-money.png', height: 20),
            const SizedBox(width: 8),
            Text(
              "${value[index]?["amount"] ?? 0}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBoardGroup(dynamic value, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "${value[index]['position']}. ${value[index]?["full_name"] ?? "-"}",
            style: TextStyle(
              fontSize: 20,
              color: (value[index]?['id'] ?? -1) != meUserId ? Colors.black : const Color.fromARGB(255, 68, 193, 255)
            ),
          ),
        ),
        SizedBox(width: 15),
        Row(
          children: [
            Image.asset('assets/top-money.png', height: 20),
            const SizedBox(width: 8),
            Text(
              "${value[index]?["amount"] ?? 0}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  void _loadReitingInfo() async {
    final response = await ApiClient.get("dashboard/progress/leader-group");
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body);
      listGroup.value = data;
    }

    final response2 = await ApiClient.get("dashboard/progress/leader-stream");
    if (response2.statusCode == 200) {
      final data = await jsonDecode(response2.body);
      listStream.value = data;
    }

    final meId = await UserStorage.getId();

    meUserId = meId ?? 0;

    setState(() => meUserId);
  }
}