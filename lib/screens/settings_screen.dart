import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colormind/theme/app_theme.dart';
import 'package:colormind/theme/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '테마 선택',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeOption(context, themeNotifier, AppTheme.defaultTheme, '기본 테마 (따뜻한 케어 & 감정 공감)'),
            _buildThemeOption(context, themeNotifier, AppTheme.calmCareTheme, '안정 & 케어 중심 테마'),
            _buildThemeOption(context, themeNotifier, AppTheme.vibrantPositiveTheme, '활력 & 긍정 강조 테마'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, ThemeNotifier themeNotifier, ThemeData theme, String title) {
    return ListTile(
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
    );
  }
}
