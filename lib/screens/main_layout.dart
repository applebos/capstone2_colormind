import 'package:flutter/material.dart';
import 'package:colormind/screens/home_screen.dart';
import 'package:colormind/screens/about_app_screen.dart';
import 'package:colormind/screens/about_ai_screen.dart';
import 'package:colormind/screens/calendar_screen.dart';
import 'package:colormind/screens/settings_screen.dart'; // SettingsScreen import 추가

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
    SettingsScreen(), // 설정 페이지 추가
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        // Overall rounded container
        margin: const EdgeInsets.all(16.0), // Margin from screen edges
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor, // 테마 색상 사용
          borderRadius: BorderRadius.circular(30), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(
                (0.1 * 255).round(),
              ), // Subtle shadow
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          // Clip for rounded corners
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors
                .transparent, // Make it transparent to show container's color
            elevation: 0, // Remove default shadow
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Theme.of(context).primaryColor, // 테마 색상 사용
            unselectedItemColor: Theme.of(
              context,
            ).textTheme.bodyMedium?.color, // 테마 색상 사용
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed, // Fixed type for even spacing
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(context, Icons.home_outlined, 0),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(context, Icons.info_outline, 1),
                label: '앱 소개',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(context, Icons.psychology_outlined, 2),
                label: 'AI 모델',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(
                  context,
                  Icons.calendar_today_outlined,
                  3,
                ), // 캘린더 아이콘
                label: '캘린더',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(context, Icons.settings, 4), // 설정 아이콘
                label: '설정', // 소통 -> 설정
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData, int index) {
    final bool isSelected = _selectedIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8.0),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(
                context,
              ).primaryColor.withAlpha((255 * 0.2).round()), // 테마 색상 사용
              shape: BoxShape.circle,
            )
          : null, // No background for unselected
      child: Icon(
        iconData,
        color: isSelected
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyMedium?.color, // 테마 색상 사용
        size: 24,
      ),
    );
  }
}
