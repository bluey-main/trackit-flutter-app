import 'package:flutter/material.dart';
import 'home.dart';
import 'budgeter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  List<Widget> body = [
    const HomePage(),
    const BudgeterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Shopping List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: "Budgeter",
          ),
        ],
      ),
      body: body[_currentIndex],
    );
  }
}
