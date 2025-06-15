import 'package:aurelius/features/chat/screens/chat_screen.dart';
import 'package:aurelius/features/habits/screens/habits_screen.dart';
import 'package:aurelius/features/home/screens/home_screen.dart';
import 'package:aurelius/features/reflection/screens/reflection_screen.dart';
import 'package:aurelius/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget activeScreen = switch (_selectedIndex) {
      0 => const HomeScreen(),
      1 => const ReflectionScreen(),
      2 => const HabitsScreen(),
      3 => const ChatScreen(),
      4 => const SettingsScreen(),
      _ => const Placeholder()
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurelius',
            style: TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            tabBackgroundColor: const Color(0xFFa68a64),
            padding: const EdgeInsets.all(16),
            gap: 6,
            onTabChange: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
                textStyle: TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 12,
                ),
              ),
              GButton(
                  icon: Icons.menu_book,
                  text: 'Reflect',
                  textStyle: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              GButton(
                  icon: Icons.show_chart,
                  text: 'Habits',
                  textStyle: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 12,
                  )),
              GButton(
                  icon: Icons.chat_bubble,
                  text: 'Dialogues',
                  textStyle: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 12,
                  )),
              GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  textStyle: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 12,
                  )),
            ],
          ),
        ),
      ),
      body: activeScreen,
    );
  }
}
