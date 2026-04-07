import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/main_screen/widgets/homework_menu.dart';
import 'package:my_app/screens/main_screen/widgets/leaderboard.dart';
import 'package:my_app/screens/main_screen/widgets/menu_drawer.dart';
import 'package:my_app/screens/main_screen/widgets/reiting_info_menu.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/user_storage.dart';

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
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            FutureBuilder<String?>(
              future: UserStorage.getPhotoUrl(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: const Color.fromARGB(255, 220, 219, 219),
                      child: const Icon(Icons.person)
                    ),
                  );
                }

                return ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Группа: $groupName",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 216, 216, 216),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/top-money.svg', height: 20),
                  const SizedBox(width: 8),
                  Text(
                    "${topcoins + topgems}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_outlined),
            onPressed: () {
              UserStorage.clearAll();
              AuthStorage.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Loginscreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 17.0,
            left: 17.0,
            right: 17.0,
            bottom: 25
          ),
          child: MediaQuery.of(context).size.width < 600 ? _buildMobile() : _buildTablet(),
        ),
      ),
    );
  }

  Widget _buildMobile() {
    return Column(
      spacing: 25,
      children: [
        HomeworkMenu(),
        ReitingInfoMenu(),
        Leaderboard(),
      ],
    );
  }

  Widget _buildTablet() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: HomeworkMenu(),
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
