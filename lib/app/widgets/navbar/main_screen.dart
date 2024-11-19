import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/home/home_page.dart';
import '../../pages/home/navbar_pages/bourse_page.dart';
import '../../pages/home/navbar_pages/budget_page.dart';
import '../../pages/home/navbar_pages/carte_page.dart';
import '../../pages/home/navbar_pages/madis_page.dart';
import 'custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(
      idNumber: '',
    ),
    CartePage(),
    MadisPage(),
    BudgetPage(),
    BoursePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
