import 'package:flutter/material.dart';
import 'package:my_app/screens/view/login_screen.dart';
import 'package:my_app/screens/view/main_screen.dart';
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Mainscreen()),
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
