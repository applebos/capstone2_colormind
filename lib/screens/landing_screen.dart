import 'package:flutter/material.dart';
import 'package:colormind/screens/main_layout.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F7EE8), // 배경색
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 그래픽(간단화, CustomPainter 필요)
            Positioned.fill(child: BackgroundHandsGraphic()),

            // 스킵 버튼
            Positioned(
              top: 24,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainLayout()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            // 본문 텍스트 및 버튼
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Image.asset(
                    'assets/colormind_logo_3.png',
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '당신의 감정을 이해하는 AI, ColorMind',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "그림 한 장, 음악 한 곡, 마음의 위로\n말보다 먼저 마음을 읽는, 감성 케어 AI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.85 * 255).round()),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 60),
                  // 플레이 버튼
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainLayout()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink[100],
                      ),
                      padding: EdgeInsets.all(18),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundHandsGraphic extends StatelessWidget {
  const BackgroundHandsGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제 손 그림은 CustomPainter로 구현하거나, SVG/이미지로 대체 가능
    return Container(); // 임시 공백, 그래픽 커스텀 필요
  }
}
