import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/cart.dart';
import 'package:my_app/screens/slpash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child: const MyApp()
    )
  );
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
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.blue.withOpacity(0.3),
          selectionHandleColor: Colors.blue,
          cursorColor: const Color.fromARGB(255, 52, 50, 50),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.5
          ),
        ),
      ),
      debugShowCheckedModeBanner: false, 
      home: Slpashscreen()
    );
  }
}
