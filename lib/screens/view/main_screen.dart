import 'package:flutter/material.dart';
import 'package:my_app/screens/view/login_screen.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/user_storage.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  String nameFull = "";

  Future<void> initUserData() async {
    final name = await UserStorage.getFullName() ?? "Tamik :)";
    setState(() {
      nameFull = name;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFEFEF),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.black, size: 30),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                nameFull,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 18),
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
      body: SingleChildScrollView(child: Column(children: [
          ],
        )),
    );
  }
}
