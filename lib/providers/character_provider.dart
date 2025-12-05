import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emotion_character.dart';
import '../models/emotion_model.dart';
import '../theme/app_theme.dart';

class CharacterProvider extends ChangeNotifier {
  EmotionCharacter _currentCharacter = EmotionCharacter.fromEmotionName(
    '기쁨',
  ); // Default
  bool _isInitialized = false;

  List<String> _topEmotions = ['기쁨']; // Default

  EmotionCharacter get currentCharacter => _currentCharacter;
  String get currentEmotionName => _topEmotions.isNotEmpty ? _topEmotions.first : '행복';
  List<String> get topEmotions => _topEmotions;
  bool get isInitialized => _isInitialized;

  CharacterProvider() {
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmotions = prefs.getStringList('last_top_emotions');
    
    if (savedEmotions != null && savedEmotions.isNotEmpty) {
      _topEmotions = savedEmotions;
      _currentCharacter = EmotionCharacter.fromEmotionName(savedEmotions.first);
    } else {
       final savedEmotion = prefs.getString('last_emotion_character');
       if (savedEmotion != null) {
         _topEmotions = [savedEmotion];
         _currentCharacter = EmotionCharacter.fromEmotionName(savedEmotion);
       }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setEmotions(List<String> emotions) async {
    if (emotions.isEmpty) return;
    
    _topEmotions = emotions;
    _currentCharacter = EmotionCharacter.fromEmotionName(emotions.first);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('last_top_emotions', emotions);
    notifyListeners();
  }

  ThemeData getCharacterTheme() {
    final baseTheme = AppTheme.warmGlassTheme;

    final emotion = allEmotions.firstWhere(
      (e) => e.name == currentEmotionName,
      orElse: () => allEmotions.first,
    );
    final textColor = emotion.textColor;
    final subTextColor = textColor.withOpacity(0.8);

    return baseTheme.copyWith(
      primaryColor: _currentCharacter.color,
      hintColor: _currentCharacter.accentColor,
      highlightColor: _currentCharacter.accentColor,
      scaffoldBackgroundColor: _currentCharacter.accentColor.withValues(
        alpha: 0.15,
      ),
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: _currentCharacter.color,
        secondary: _currentCharacter.accentColor,
        surface: Colors.white.withValues(alpha: 0.9),
      ),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: baseTheme.appBarTheme.titleTextStyle?.copyWith(
          color: textColor,
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(color: textColor),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(color: subTextColor),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(color: subTextColor),
      ),
      iconTheme: IconThemeData(color: textColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: WidgetStateProperty.all(_currentCharacter.color),
          shadowColor: WidgetStateProperty.all(
            _currentCharacter.color.withValues(alpha: 0.4),
          ),
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: _currentCharacter.accentColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  LinearGradient getBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _currentCharacter.accentColor.withValues(alpha: 0.2),
        _currentCharacter.accentColor.withValues(alpha: 0.1),
        _currentCharacter.color.withValues(alpha: 0.05),
      ],
    );
  }
}
