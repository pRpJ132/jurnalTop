import 'package:flutter/material.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/widgets/attendance.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/widgets/average_progress.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/widgets/homework_menu.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/widgets/leaderboard.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/widgets/reiting_info_menu.dart';
import 'package:my_app/services/user_storage.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String nameFull = "";
  String groupName = "";
  int topcoins = 0;
  int topgems = 0;

  Future<void> initUserData() async {
    final name = await UserStorage.getFullName() ?? "Tamik";
    final group = await UserStorage.getGroupName() ?? "Unknown";
    final coins = await UserStorage.getTopCoins() ?? 0;
    final gems = await UserStorage.getTopGems() ?? 0;
    setState(() {
      nameFull = name;
      groupName = group;
      topcoins = coins;
      topgems = gems;
    });
  }

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 17.0,
          left: 17.0,
          right: 17.0,
          bottom: 25
        ),
        child: MediaQuery.of(context).size.width < 600 ? _buildMobile() : _buildTablet(),
      ),
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        Attendance(),
        SizedBox(height: 25),
        AverageProgress(),
        SizedBox(height: 25),
        HomeworkMenu(),
        SizedBox(height: 25),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              ReitingInfoMenu(),
              Leaderboard(),
            ],
          )
        ),
      ],
    );
  }

  Widget _buildTablet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            spacing: 25,
            children: [
              HomeworkMenu(),
              Attendance(),
              AverageProgress(),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            spacing: 25,
            children: [
              ReitingInfoMenu(),
              Leaderboard(),
            ],
          ),
        ),
      ],
    );
  }
}
