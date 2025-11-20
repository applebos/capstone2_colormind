import 'package:flutter/material.dart';

class AppTheme {
  // 1. 기본 테마 (따뜻한 케어 & 감정 공감)
  static final ThemeData defaultTheme = ThemeData(
    primaryColor: const Color(0xFFE91E63), // 주 컬러: 푸시아 핑크
    hintColor: const Color(0xFFFF9800), // 보조1: 오렌지
    highlightColor: const Color(0xFF00B8A9), // 포인트: 청록
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // 네추럴: 화이트
    cardColor: const Color(0xFFFFF9C4), // 카드 색상: 라이트 옐로우
    dividerColor: const Color(0xFFFFE4EC), // 구분선(디바이더): 라이트 핑크
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF232323)), // 텍스트 딥 블랙
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF232323), // 텍스트 딥 블랙
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF232323)), // 텍스트 딥 블랙
      bodyMedium: TextStyle(color: Color(0xFF232323)), // 텍스트 딥 블랙
      bodySmall: TextStyle(color: Color(0xFF232323)), // 텍스트 딥 블랙
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE91E63), // 주 컬러: 푸시아 핑크
        foregroundColor: Colors.white, // 흰색
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );

  // 2. 안정 & 케어 중심 테마
  static final ThemeData calmCareTheme = ThemeData(
    primaryColor: const Color(0xFF00B8A9), // 주 컬러: 청록
    hintColor: const Color(0xFFD2B7E5), // 보조1: 옅은 라일락
    highlightColor: const Color(0xFFD0F7F4), // 보조2/포인트: 파스텔 민트
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // 네추럴: 화이트
    cardColor: const Color(0xFFE9D8FD), // 카드 색상: 라이트 라일락
    dividerColor: const Color(0xFFF2E6FC), // 구분선(디바이더): 연라일락
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF232323)),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF232323),
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF232323)),
      bodyMedium: TextStyle(color: Color(0xFF232323)),
      bodySmall: TextStyle(color: Color(0xFF232323)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00B8A9), // 주 컬러: 청록
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );

  // 3. 활력 & 긍정 강조 테마
  static final ThemeData vibrantPositiveTheme = ThemeData(
    primaryColor: const Color(0xFFFF9800), // 주 컬러: 오렌지
    hintColor: const Color(0xFFFF69B4), // 보조1: 생동감 있는 분홍
    highlightColor: const Color(0xFFD0F7F4), // 보조2/포인트: 파스텔 민트
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // 네추럴: 화이트
    cardColor: const Color(0xFFFFE0B2), // 카드 색상: 연주황
    dividerColor: const Color(0xFFE0F7FA), // 구분선(디바이더): 라이트 블루 그레이
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF232323)),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF232323),
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF232323)),
      bodyMedium: TextStyle(color: Color(0xFF232323)),
      bodySmall: TextStyle(color: Color(0xFF232323)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9800), // 주 컬러: 오렌지
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
