import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/main_screen/screens/advertisements_screen/advertisements_screen.dart';
import 'package:my_app/screens/main_screen/screens/assessments_screen/assessments_screen.dart';
import 'package:my_app/screens/main_screen/screens/homework_screen/homework_screen.dart';
import 'package:my_app/screens/main_screen/screens/main_screen/main_screen.dart';
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
  String nameFull = "";
  String groupName = "";
  int topcoins = 0;
  int topgems = 0;

  final pageIndex = ValueNotifier<int>(0);

  List<Widget> pages = [
    Mainscreen(),
    SchedulesScreen(),
    AssessmentsScreen(),
    HomeworkScreen(),
    SizedBox.fromSize(),
    AdvertisementsScreen(),
    SizedBox.fromSize(),
    ReviewsStudentScreen(),
    SizedBox.fromSize(),
    SizedBox.fromSize(),
    SizedBox.fromSize(),
    SizedBox.fromSize(),
    SizedBox.fromSize(),
    SizedBox.fromSize(),
  ];

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
  void dispose() {
    pageIndex.dispose();
    super.dispose();
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
                color: const Color.fromARGB(255, 240, 240, 240),
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
      body: ValueListenableBuilder<int>(
        valueListenable: pageIndex,
        builder: (context, data, _) {
          if (data >= 0 && data < pages.length) {
            return pages[data];
          }
          return SizedBox.shrink();
        }
      ),
    );
  }
}
