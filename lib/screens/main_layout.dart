import 'dart:ui'; // Import for ImageFilter
import 'package:flutter/material.dart';

import 'package:colormind/screens/home_screen.dart';
import 'package:colormind/screens/about_app_screen.dart';
import 'package:colormind/screens/about_ai_screen.dart';
import 'package:colormind/screens/calendar_screen.dart';
import 'package:colormind/screens/character_preview_screen.dart';
import 'package:colormind/theme/app_theme.dart';
 // SettingsScreen import 추가

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AboutAppScreen(),
    AboutAIScreen(),
    CalendarScreen(),
    CharacterPreviewScreen(), // 캐릭터 프리뷰 페이지로 변경
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(Theme.of(context)),
        ),
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Pill shape
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), 
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9), 
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: const Color(0xFFBCAAA4), 
                showSelectedLabels: false, // Hide labels for cleaner look (like reference)
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _buildIcon(context, Icons.home_rounded, 0),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(context, Icons.info_outline_rounded, 1),
                    label: '앱 소개',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(context, Icons.psychology_outlined, 2),
                    label: 'AI 모델',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(
                      context,
                      Icons.calendar_today_rounded,
                      3,
                    ),
                    label: '캘린더',
                  ),
                  BottomNavigationBarItem(
                    icon: _buildIcon(context, Icons.face_rounded, 4),
                    label: '캐릭터',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData, int index) {
    final bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(12.0),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(context).primaryColor, // Solid primary color for active
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: Icon(
        iconData,
        color: isSelected
            ? Colors.white // White icon on colored background
            : const Color(0xFFBCAAA4),
        size: 24,
      ),
    );
  }
}
