import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/main_screen/main_screens.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/user_storage.dart';

class Slpashscreen extends StatefulWidget {
  const Slpashscreen({super.key});

  @override
  State<Slpashscreen> createState() => _SlpashscreenState();
}

class _SlpashscreenState extends State<Slpashscreen> {
  @override
  void initState() {
    super.initState();
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.height * 0.45,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.37,
                ),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void LoadData() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (await UserStorage.isValidAllData() == true &&
        await AuthStorage.isValid() == true) {
      final response = await ApiClient.get("settings/user-info");
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        final username = await UserStorage.getUsername();
        final password = await UserStorage.getPassword();
        await UserStorage.clearAll();
        await UserStorage.saveUserInfo(
          photoUrl: data["photo"],
          fullName: data["full_name"],
          groupName: data["groups"][0]["name"],
          id: data["student_id"].toInt(),
          topcoins: data["gaming_points"][0]["points"].toInt(),
          topgems: data["gaming_points"][1]["points"].toInt(),
          username: username ?? "",
          password: password ?? "",
        );
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Mainscreens()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Loginscreen()),
        (route) => false,
      );
    }
  }
}
