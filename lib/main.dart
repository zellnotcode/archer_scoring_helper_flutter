import 'package:archer_score_helper/screen/game_screen.dart';
import 'package:archer_score_helper/screen/user_screen.dart';
import 'package:flutter/material.dart';

import 'constant/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const GameScreen(),
    const UserScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: CustomColor.blue,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/ic_history.png",
                color: CustomColor.white,
              ),
              activeIcon: Image.asset(
                "assets/ic_history.png",
                color: CustomColor.yellow,
              ),
              label: "History",
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/ic_person.png",
                  color: CustomColor.white,
                ),
                activeIcon: Image.asset(
                  "assets/ic_person.png",
                  color: CustomColor.yellow,
                ),
                label: "Data"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
