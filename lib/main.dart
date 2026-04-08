import 'package:flutter/material.dart';
import 'package:my_app/screens/slpash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF9AC9C0),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false, 
      home: Slpashscreen()
    );
  }
}
