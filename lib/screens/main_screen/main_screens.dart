import 'package:flutter/material.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/main_screen/screens/FAQ_screen/FAQ_screen.dart';
import 'package:my_app/screens/main_screen/screens/advertisements_screen/advertisements_screen.dart';
import 'package:my_app/screens/main_screen/screens/assessments_screen/assessments_screen.dart';
import 'package:my_app/screens/main_screen/screens/awards_screen/awards_screen.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/homework_screen.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/main_screen.dart';
import 'package:my_app/screens/main_screen/screens/market_screen/market_screen.dart';
import 'package:my_app/screens/main_screen/screens/personal_account_srceen/personal_account_screen.dart';
import 'package:my_app/screens/main_screen/screens/reviews_student_screen/reviews_student_screen.dart';
import 'package:my_app/screens/main_screen/screens/schedules_screen/schedules_screen.dart';
import 'package:my_app/screens/main_screen/widgets/menu_drawer.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/user_storage.dart';

class Mainscreens extends StatefulWidget {
  const Mainscreens({super.key});

  @override
  State<Mainscreens> createState() => _MainscreensState();
}

class _MainscreensState extends State<Mainscreens> {
  String groupName = "";
  int topcoins = 0;
  int topgems = 0;

  final pageIndex = ValueNotifier<String>("main");

  Map<String, Widget> pages = {
    "main": Mainscreen(),
    "schedule": SchedulesScreen(),
    "grades": AssessmentsScreen(),
    "homework": HomeworkScreen(),
    "announcements": AdvertisementsScreen(),
    "awards": AwardsScreen(),
    "feedback": ReviewsStudentScreen(),
    "profile": PersonalAccountScreen(),
    "faq": FaqScreen(),
    "market": MarketScreen(),
  };

  Future<void> initUserData() async {
    final group = await UserStorage.getGroupName() ?? "Unknown";
    final coins = await UserStorage.getTopCoins() ?? 0;
    final gems = await UserStorage.getTopGems() ?? 0;
    setState(() {
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
  void dispose() {
    pageIndex.dispose();
    super.dispose();
  }

  Widget _buildContainerInfoPoint(String assetImage, String text) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 240, 240, 240),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Image.asset(assetImage, height: 20),
          const SizedBox(width: 8),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(pageIndex: pageIndex,),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            FutureBuilder<String?>(
              future: UserStorage.getPhotoUrl(),
              builder: (context, snapshot) {
                return ClipOval(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: !snapshot.hasData ? CircularProgressIndicator() : Image.network(
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
            Row(
              spacing: 20,
              mainAxisSize: .min,
              children: [
                if (MediaQuery.of(context).size.width >= 600) ...[
                  _buildContainerInfoPoint(
                    "assets/top-coin.png",
                    topcoins.toString(),
                  ),
                  _buildContainerInfoPoint(
                    "assets/top-gem.png",
                    topgems.toString(),
                  ),
                ],
                _buildContainerInfoPoint(
                  "assets/top-money.png",
                  "${topcoins+topgems}"
                ),
              ],
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
      body: ValueListenableBuilder<String>(
        valueListenable: pageIndex,
        builder: (context, data, _) {
          return pages[data] ?? SizedBox.shrink();
        }
      ),
    );
  }
}
