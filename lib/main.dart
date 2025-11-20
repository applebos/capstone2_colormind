import 'package:colormind/music_service.dart';
// import 'package:colormind/screens/crop_screen.dart';
import 'package:colormind/screens/main_layout.dart';
import 'package:colormind/youtube_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colormind/theme/app_theme.dart';
import 'package:colormind/theme/theme_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => YouTubeService()),
        ChangeNotifierProvider(create: (context) => MusicService()),
        ChangeNotifierProvider(create: (context) => ThemeNotifier(AppTheme.defaultTheme)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'ColorMind',
      theme: themeNotifier.currentTheme,
      home: const MainLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
