import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_app/screens/view/login_screen.dart';
import 'package:my_app/screens/widgets/homework_menu.dart';
import 'package:my_app/screens/widgets/menu_drawer.dart';
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
  String devicePlatform = "";
  String deviceOsVersion = "";

  Future<void> initUserData() async {
    final name = await UserStorage.getFullName() ?? "Tamik :)";
    final group = await UserStorage.getGroupName() ?? "Guest";
    final coins = await UserStorage.getTopCoins() ?? 0;
    final gems = await UserStorage.getTopGems() ?? 0;
    final platform = await UserStorage.getDevicePlatform() ?? "Unknown";
    final osVersion = await UserStorage.getDeviceOsVersion() ?? "Unknown";
    setState(() {
      nameFull = name;
      groupName = group;
      topcoins = coins;
      topgems = gems;
      devicePlatform = platform;
      deviceOsVersion = osVersion;
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
      backgroundColor: const Color(0xFF9AC9C0),
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFEFEF),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.black, size: 30),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 17.0,
                left: 17.0,
                right: 17.0,
              ),
              child: HomeworkMenu(),
            ),
          ],
        ),
      ),
    );
  }
}
