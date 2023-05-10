import 'package:fitnessapp/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/home_screen.dart';
import 'package:fitnessapp/workout_library_screen.dart';
import 'package:fitnessapp/coach_session_screen.dart';
import 'package:fitnessapp/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/providers/user_provider.dart';
import 'package:fitnessapp/workout_library_screen.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  _NavigationPage createState() => _NavigationPage();
}

class _NavigationPage extends State<NavigationPage> {
  int _selectedIndex = 0;

  void _navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    UserHome(),
    MyHomePage(),
    const CoachSession(),
    const UserProfile(),
  ];

  List<String> titleList = [
    'Home',
    'Workout Library',
    'Workout Session',
    'Profile'
  ];

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titleList[_selectedIndex], style: const TextStyle(
                color: Color(0xff004AAD),
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),)
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigationBottomBar,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.shelves),label: 'Library'),
            BottomNavigationBarItem(icon: Icon(Icons.today_outlined),label: 'Session'),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
          ],
          selectedItemColor: const Color(0xff004AAD),
        ),
      ),
    );
  }
}

