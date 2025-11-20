import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/gemini_service.dart';
import 'glass_card.dart';

class GeminiRecommendationCard extends StatefulWidget {
  final List<String> emotionNames;

  const GeminiRecommendationCard({super.key, required this.emotionNames});

  @override
  State<GeminiRecommendationCard> createState() =>
      _GeminiRecommendationCardState();
}

class _GeminiRecommendationCardState extends State<GeminiRecommendationCard> {
  late final Future<String> _recommendationFuture;
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 한 번만 Gemini API를 호출합니다.
    _recommendationFuture = _geminiService.getRecommendations(
      widget.emotionNames,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '당신을 위한 맞춤 추천',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<String>(
            future: _recommendationFuture,
            builder: (context, snapshot) {
              // 로딩 중일 때
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // 에러가 발생했을 때
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '추천을 불러오는 데 실패했습니다: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              // 데이터가 없을 때
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('추천 내용이 없습니다.'));
              }

              // 성공적으로 데이터를 받았을 때 마크다운으로 표시
              return MarkdownBody(
                data: snapshot.data!,
                styleSheet: MarkdownStyleSheet(
                  h3: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 2.5,
                  ),
                  p: const TextStyle(fontSize: 15, height: 1.6),
                  listBullet: const TextStyle(fontSize: 15),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
