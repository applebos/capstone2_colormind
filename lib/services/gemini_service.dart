import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey = 'Gemini API';

  Future<String> getRecommendations(List<String> emotions) async {
   
    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);

    final prompt =
        '''
      사용자의 사진에서 주로 '${emotions.join(', ')}'와 같은 감정이 분석되었습니다.
      이 감정들에 어울리는 아래 항목들을 각각 2~3가지씩 추천해주세요.
      결과는 아래 형식에 맞춰 간결한 마크다운 리스트로, 반드시 한국어로만 응답해주세요.

      ### 🏃 추천 활동
      - 활동 1
      - 활동 2

      ### 🎬 추천 영화/드라마
      - 영화/드라마 1
      - 영화/드라마 2

      ### 🎵 추천 음악
      - 음악 1
      - 음악 2
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return response.text ?? "추천 내용을 생성하지 못했습니다.";
    } catch (e) {
      // 4. 오류 발생 시, 콘솔에 정확한 원인을 출력합니다.
      debugPrint(">>> 최종 Gemini API 오류: $e");
      return "추천을 받아오는 중 오류가 발생했습니다. 네트워크 연결을 확인하거나 잠시 후 다시 시도해주세요.";
    }
  }
}
