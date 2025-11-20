import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:colormind/database_helper.dart';
import 'package:colormind/models/emotion_model.dart';
import 'package:colormind/music_service.dart';
import 'package:colormind/widgets/youtube_card.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../widgets/circular_emotion_indicator.dart';
import '../widgets/glass_card.dart';
import '../widgets/in_app_music_player.dart';
import 'package:colormind/screens/all_emotions_screen.dart';

// Gemini 추천 카드를 사용하기 위해 import 문을 추가합니다.
import 'package:colormind/widgets/gemini_recommendation_card.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final List<double> probVector;
  final List<int> predVector;

  const ResultScreen({
    super.key,
    required this.image,
    required this.probVector,
    required this.predVector,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final List<String> _top3Emotions;
  late final List<MapEntry<Emotion, double>> _sortedEmotions;
  late final DatabaseHelper _dbHelper;
  String? _imageMetadata;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _calculateTopEmotions();
    _initData();
  }

  Future<void> _initData() async {
    await _extractMetadata();
    await _saveResult();
  }

  Future<void> _extractMetadata() async {
    final bytes = await widget.image.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image != null) {
      setState(() {
        _imageMetadata = image.exif.toString();
      });
    }
  }

  Future<void> _saveResult() async {
    final emotions = <String, double>{};
    for (int i = 0; i < allEmotions.length; i++) {
      emotions[allEmotions[i].name] = widget.probVector[i];
    }

    final data = {
      'date': DateTime.now().toUtc().toIso8601String(),
      'imagePath': widget.image.path,
      'emotions': jsonEncode(emotions),
      'metadata': _imageMetadata ?? '',
    };
    await _dbHelper.insertEmotionData(data);
  }

  void _calculateTopEmotions() {
    final emotionProbabilities = <Emotion, double>{};
    for (int i = 0; i < allEmotions.length; i++) {
      emotionProbabilities[allEmotions[i]] = widget.probVector[i];
    }

    _sortedEmotions = emotionProbabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    _top3Emotions = _sortedEmotions.take(3).map((e) => e.key.name).toList();
  }

  String _getCombinedEmotionsComment() {
    if (_sortedEmotions.isEmpty) {
      return "감정을 분석하고 있어요. 잠시만 기다려주세요.";
    }

    final top3EmotionEntries = _sortedEmotions.take(3).toList();
    if (top3EmotionEntries.length < 3) {
      return "감정을 분석하고 있어요. 잠시만 기다려주세요.";
    }

    final keyword1 = top3EmotionEntries[0].key.commentKeyword;
    final keyword2 = top3EmotionEntries[1].key.commentKeyword;
    final keyword3 = top3EmotionEntries[2].key.commentKeyword;

    return "오늘은 전반적으로 $keyword1, $keyword2, $keyword3의 감정이 느껴지는 날이네요.\n"
        "이 감정들이 당신의 하루를 다채롭게 만들고 있어요.\n"
        "스스로의 마음에 귀 기울여보는 멋진 하루 보내세요.";
  }

  String _getSentimentComment() {
    if (_sortedEmotions.isEmpty) {
      return "감정 조합을 분석하고 있어요.";
    }

    int positiveCount = 0;
    int negativeCount = 0;
    int neutralCount = 0;

    final top3EmotionEntries = _sortedEmotions.take(3).toList();

    for (var entry in top3EmotionEntries) {
      final emotion = entry.key;
      switch (emotion.sentiment) {
        case EmotionSentiment.positive:
          positiveCount++;
          break;
        case EmotionSentiment.negative:
          negativeCount++;
          break;
        case EmotionSentiment.neutral:
          neutralCount++;
          break;
      }
    }

    if (positiveCount == 3) {
      return "그림에서 따뜻하고 긍정적인 분위기가 물씬 느껴져요.";
    } else if (negativeCount == 3) {
      return "그림이 전하는 감정은 무겁고 슬픈 느낌이에요.";
    } else if (positiveCount == 2 && negativeCount == 1) {
      return "밝은 분위기 속에 살짝 어두운 감정이 스며있어요.";
    } else if (negativeCount == 2 && positiveCount == 1) {
      return "어두운 감정 속에서도 희망이 느껴져요.";
    } else if (positiveCount > 0 && negativeCount > 0 && neutralCount > 0) {
      return "복합적인 감정이 공존하는, 해석이 다양한 그림이에요.";
    } else if (positiveCount > 0 && neutralCount > 0) {
      return "따뜻한 감정과 함께 생각을 불러일으켜요.";
    } else if (negativeCount > 0 && neutralCount > 0) {
      return "어두운 분위기 속에서 깊은 의미를 담고 있어요.";
    } else if (neutralCount == 3) {
      return "다양한 해석이 가능한 복합적인 그림이에요.";
    } else {
      return "다채로운 감정들이 조화롭게 어우러져 있네요.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor, // 네추럴 화이트
      appBar: AppBar(
        title: Text(
          '분석 결과',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .appBarTheme
                .titleTextStyle
                ?.color,
          ), // 텍스트 딥 블랙
        ),
        backgroundColor: Theme
            .of(context)
            .appBarTheme
            .backgroundColor,
        elevation: Theme
            .of(context)
            .appBarTheme
            .elevation,
        iconTheme: Theme
            .of(context)
            .appBarTheme
            .iconTheme, // 텍스트 딥 블랙
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      widget.image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '주요 감정',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.color, // 텍스트 딥 블랙
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    alignment: WrapAlignment.center,
                    children: _sortedEmotions.take(3).map((entry) {
                      final emotion = entry.key;
                      return Chip(
                        avatar: Icon(
                          emotion.icon,
                          color:
                          emotion.backgroundColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                        label: Text(
                          emotion.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: emotion.backgroundColor,
                        labelStyle: TextStyle(
                          color:
                          emotion.backgroundColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                        side: BorderSide(
                          color: emotion.backgroundColor.withAlpha(
                            (0.5 * 255).round(),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getCombinedEmotionsComment(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.color, // 텍스트 딥 블랙
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '감정 조합 분석',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.color, // 텍스트 딥 블랙
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getSentimentComment(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.color, // 텍스트 딥 블랙
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '감정별 분석 확률',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(
                        context,
                      )
                          .textTheme
                          .bodyMedium
                          ?.color, // 텍스트 딥 블랙
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _sortedEmotions.take(3).map((entry) {
                      final emotion = entry.key;
                      final probability = entry.value;
                      final index = allEmotions.indexWhere(
                            (e) => e.name == emotion.name,
                      );
                      final isHighlighted = widget.predVector[index] == 1;
                      return CircularEmotionIndicator(
                        context: context,
                        emotion: emotion,
                        probability: probability,
                        isHighlighted: isHighlighted,
                      );
                    }).toList(),
                  ),
                  if (_sortedEmotions.length > 3)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllEmotionsScreen(
                                    sortedEmotions: _sortedEmotions,
                                    predVector: widget.predVector,
                                  ),
                            ),
                          );
                        },
                        child: Text(
                          '자세히 보기',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ), // 주 컬러 푸시아 핑크
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            InAppMusicPlayer(
              musicService: Provider.of<MusicService>(context, listen: false),
              recommendedSongs: _top3Emotions
                  .map(
                    (e) => allEmotions
                        .firstWhere((em) => em.name == e)
                        .musicFileNames
                        .first,
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            YouTubeCard(emotionNames: _top3Emotions),

            // ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
            // Gemini 추천 카드 추가
            // ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
            const SizedBox(height: 24), // 유튜브 카드와 Gemini 카드 사이의 간격
            // _top3Emotions 리스트가 비어있지 않을 때만 Gemini 카드를 보여줍니다.
            if (_top3Emotions.isNotEmpty)
              GeminiRecommendationCard(emotionNames: _top3Emotions),

            // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.replay_outlined),
              label: const Text('다른 사진으로 분석하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                // 주 컬러 푸시아 핑크
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}