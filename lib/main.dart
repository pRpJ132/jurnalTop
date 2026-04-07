import 'package:flutter/material.dart';
import 'package:my_app/screens/slpash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF9AC9C0),
      ),
      debugShowCheckedModeBanner: false, 
      home: Slpashscreen()
    );
  }
}
