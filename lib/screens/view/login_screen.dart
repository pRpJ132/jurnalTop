import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:my_app/network/api_client.dart';
import 'package:my_app/screens/view/main_screen.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/logger.dart';
import 'package:my_app/services/user_storage.dart';
import 'package:toastification/toastification.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool isPasswordVisible = false;
  bool isTapButton = false;

  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                children: [
                  const SizedBox(height: 120),

                  const Text("Journal", style: TextStyle(fontSize: 76)),

                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 47),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.red, width: 10),
                        right: BorderSide(color: Colors.red, width: 10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: TextField(
                            controller: _controllerUsername,
                            decoration: const InputDecoration(
                              hintText: "Логин",
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 187, 187, 187),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 129, 129, 129),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: TextField(
                            controller: _controllerPassword,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Пароль",
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 187, 187, 187),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 129, 129, 129),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        GestureDetector(
                          onTap: () => LoginFun(),
                          child: SizedBox(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                              child: isTapButton
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      constraints: BoxConstraints(
                                        minHeight: 27,
                                        minWidth: 27,
                                      ),
                                    )
                                  : const Text(
                                      "Вход",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> LoginFun() async {
    if (isTapButton) return;
    setState(() {
      isTapButton = true;
    });

    String username = "Thaga_xy80"; // _controllerUsername.text;
    String password = "K46b0n7N"; //_controllerPassword.text;

    try {
      Response response = await ApiClient.post("auth/login", {
        "application_key":
            "6a56a5df2667e65aab73ce76d1dd737f7d1faef9c52e8b8c55ac75f565d8e8a6",
        "id_city": null,
        "password": password,
        "username": username,
      });

      if (response.statusCode == 200) {
        dynamic data = await jsonDecode(response.body);
        await AuthStorage.saveTokens(
          data["access_token"],
          data["refresh_token"],
        );

        response = await ApiClient.get("settings/user-info");
        if (response.statusCode == 200) {
          data = await jsonDecode(response.body);
          print(data);
          await UserStorage.clearAll();
          await UserStorage.saveUserInfo(
            photoUrl: data["photo"],
            fullName: data["full_name"],
            groupName: data["groups"][0]["name"],
            id: data["student_id"].toInt(),
            topcoins: data["gaming_points"][0]["points"].toInt(),
            topgems: data["gaming_points"][1]["points"].toInt(),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const Mainscreen()),
            (route) => false,
          );
        } else {
          final data = await jsonDecode(response.body);
          logger.e(
            "Login failed with status code: ${response.statusCode}, ${data["message"]}",
          );
          toastification.show(
            context: context,
            title: Text(data["message"]),
            autoCloseDuration: const Duration(seconds: 4),
            style: ToastificationStyle.fillColored,
            type: ToastificationType.error,
          );
        }
      } else if (response.statusCode == 422) {
        final data = await jsonDecode(response.body);
        logger.e(
          "Login failed: ${data[0]["message"]}, status code: ${response.statusCode}",
        );
        toastification.show(
          context: context,
          title: Text(data[0]["message"]),
          autoCloseDuration: const Duration(seconds: 4),
          style: ToastificationStyle.fillColored,
          type: ToastificationType.warning,
        );
      } else {
        final data = await jsonDecode(response.body);
        logger.e(
          "Login failed with status code: ${response.statusCode}, ${data["message"]}",
        );
        toastification.show(
          context: context,
          title: Text(data["message"]),
          autoCloseDuration: const Duration(seconds: 4),
          style: ToastificationStyle.fillColored,
          type: ToastificationType.error,
        );
      }
      setState(() {
        isTapButton = false;
      });
    } catch (e) {
      logger.e("Login exception: $e");
      setState(() {
        isTapButton = false;
      });
    }
  }
}
