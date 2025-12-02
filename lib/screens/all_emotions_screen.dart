import 'package:flutter/material.dart';
import 'package:colormind/models/emotion_model.dart';
import 'package:colormind/widgets/emotion_indicator.dart';
import 'package:colormind/theme/app_theme.dart';


class AllEmotionsScreen extends StatelessWidget {
  final List<MapEntry<Emotion, double>> sortedEmotions;
  final List<int> predVector;

  const AllEmotionsScreen({
    super.key,
    required this.sortedEmotions,
    required this.predVector,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '모든 감정 분석 확률',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ), // 텍스트 딥 블랙
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        iconTheme: Theme.of(context).appBarTheme.iconTheme, // 텍스트 딥 블랙
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(Theme.of(context)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100.0, bottom: 100.0, left: 24.0, right: 24.0), // Added vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '그림에서 분석된 모든 감정의 확률입니다.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ...sortedEmotions.map((entry) {
                final emotion = entry.key;
                final probability = entry.value;
                final index = allEmotions.indexWhere(
                  (e) => e.name == emotion.name,
                );
                final isHighlighted = predVector[index] == 1;
                return EmotionIndicator(
                  context: context,
                  emotion: emotion.name,
                  probability: probability,
                  isHighlighted: isHighlighted,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
