import 'package:flutter/material.dart';
import 'package:colormind/widgets/glass_container.dart';

import 'package:provider/provider.dart';
import 'package:colormind/theme/app_theme.dart';
import 'about_app_screen.dart';
import 'debug_character_screen.dart';
import 'package:colormind/theme/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.info_outline,
              title: '앱 정보',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutAppScreen()),
                );
              },
            ),
            const SizedBox(height: 8), // Adjusted spacing
            // Debug Mode
            _buildSettingsTile(
              context,
              icon: Icons.bug_report_outlined,
              title: '디버그 모드: 캐릭터 보기',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DebugCharacterScreen()),
                );
              },
            ),
            const SizedBox(height: 32), // Adjusted spacing
            Text(
              '테마 선택',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(context, themeNotifier, AppTheme.warmGlassTheme, '웜 & 리퀴드 글라스 테마 (New)'),
            _buildThemeOption(context, themeNotifier, AppTheme.defaultTheme, '기본 테마 (따뜻한 케어 & 감정 공감)'),
            _buildThemeOption(context, themeNotifier, AppTheme.calmCareTheme, '안정 & 케어 중심 테마'),
            _buildThemeOption(context, themeNotifier, AppTheme.vibrantPositiveTheme, '활력 & 긍정 강조 테마'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      borderRadius: 15,
      blur: 10,
      opacity: 0.3,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeNotifier themeNotifier, ThemeData theme, String title) {
    return GlassContainer(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      borderRadius: 15,
      blur: 10,
      opacity: 0.3,
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        onTap: () {
          themeNotifier.setTheme(theme);
        },
        leading: Radio<ThemeData>(
          value: theme,
          groupValue: themeNotifier.currentTheme,
          onChanged: (ThemeData? value) {
            if (value != null) {
              themeNotifier.setTheme(value);
            }
          },
        ),
      ),
    );
  }
}
