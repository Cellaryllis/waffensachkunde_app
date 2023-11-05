import 'package:flutter/material.dart';
import 'package:waffensachkunde_app/pages/dashboard.dart';
import 'package:waffensachkunde_app/singletons/learn_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LearnDataManager().load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = const Color.fromARGB(255, 102, 58, 183);

    return MaterialApp(
      title: 'Waffensachkunde Learning App',
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData(
            thumbVisibility: MaterialStatePropertyAll(true),
            thumbColor: MaterialStatePropertyAll(primaryColor)),
        canvasColor: const Color.fromARGB(255, 37, 37, 37),
        colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            onBackground: const Color.fromARGB(255, 216, 216, 216),
            background: const Color.fromARGB(255, 37, 37, 37)),
        cardTheme: const CardTheme(
            color: Color.fromARGB(255, 22, 22, 22),
            surfaceTintColor: Colors.white),
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const Dashboard(),
    );
  }
}
