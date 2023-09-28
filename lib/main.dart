import 'package:flutter/material.dart';
// import './pages/main_page.dart';
import './pages/splash_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //init hive
  await Hive.initFlutter();

  // ignore: unused_local_variable
  var box = await Hive.openBox("firstBox");
  // ignore: unused_local_variable
  var box2 = await Hive.openBox("secondBox");
  // ignore: unused_local_variable
  var totalBudgetBox = await Hive.openBox("totalBudgetBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
