import 'package:flutter/material.dart';

class EmotionCharacter {
  final String name;
  final Color color;
  final Color accentColor;
  final List<String> greetings;
  final List<String> comfortMessages;
  final CharacterAppearance appearance;

  const EmotionCharacter({
    required this.name,
    required this.color,
    required this.accentColor,
    required this.greetings,
    required this.comfortMessages,
    required this.appearance,
  });

  // Factory to get character by emotion name
  static EmotionCharacter fromEmotionName(String emotionName) {
    return _characters[emotionName] ?? _defaultCharacter;
  }
}

enum CharacterAppearance {
  round, // Circle shape (Joy, Trust)
  droplet, // Teardrop shape (Sadness)
  spiky, // Spiky shape (Anger, Fear)
  cloud, // Cloud shape (Anticipation, Surprise)
  heart, // Heart shape (Love)
}

final EmotionCharacter _defaultCharacter = EmotionCharacter(
  name: '마음이',
  color: const Color(0xFFFF8A65), // Warm Coral
  accentColor: const Color(0xFFFFCCBC),
  greetings: ['안녕하세요! 당신의 마음을 들려주세요.'],
  comfortMessages: ['오늘 하루는 어땠나요?'],
  appearance: CharacterAppearance.round,
);

final Map<String, EmotionCharacter> _characters = {
  '행복': EmotionCharacter(
    name: '햇살이',
    color: const Color(0xFFFFEB3B), // Bright Yellow
    accentColor: const Color(0xFFFFF59D),
    greetings: ['야호! 오늘 정말 신나는 날이에요!', '당신의 미소가 세상을 밝혀요!'],
    comfortMessages: ['행복한 순간을 마음껏 즐기세요!', '웃음은 최고의 보약이래요.'],
    appearance: CharacterAppearance.round,
  ),
  '신뢰': EmotionCharacter(
    name: '믿음이',
    color: const Color(0xFF1565C0), // Strong Blue
    accentColor: const Color(0xFF90CAF9),
    greetings: ['든든한 하루가 될 거예요.', '서로 믿고 의지하는 마음이 중요해요.'],
    comfortMessages: ['당신은 충분히 잘하고 있어요.', '흔들리지 않는 마음을 응원해요.'],
    appearance: CharacterAppearance.round,
  ),
  '두려움': EmotionCharacter(
    name: '덜덜이',
    color: const Color(0xFF212121), // Almost Black
    accentColor: const Color(0xFF616161),
    greetings: ['조금 무섭지만... 용기를 내볼게요.', '괜찮아요, 제가 곁에 있을게요.'],
    comfortMessages: ['두려움은 용기의 시작이에요.', '천천히 한 걸음씩 나아가요.'],
    appearance: CharacterAppearance.spiky,
  ),
  '놀람': EmotionCharacter(
    name: '깜짝이',
    color: const Color(0xFFFF00FF), // Magenta
    accentColor: const Color(0xFFFF80AB),
    greetings: ['와우! 정말 놀라운 일이네요!', '새로운 발견은 언제나 즐거워요.'],
    comfortMessages: ['예상치 못한 행운이 찾아올 거예요!', '놀라움은 삶의 활력소죠.'],
    appearance: CharacterAppearance.cloud,
  ),
  '슬픔': EmotionCharacter(
    name: '울먹이',
    color: const Color(0xFF2196F3), // Water Blue
    accentColor: const Color(0xFF90CAF9),
    greetings: ['오늘은 조금 쉬어가도 괜찮아요.', '눈물은 마음을 씻어주는 비와 같아요.'],
    comfortMessages: ['슬픔이 지나가면 무지개가 뜰 거예요.', '당신의 마음을 토닥여줄게요.'],
    appearance: CharacterAppearance.droplet,
  ),
  '혐오': EmotionCharacter(
    name: '질퍽이',
    color: const Color(0xFF556B2F), // Dull Olive
    accentColor: const Color(0xFFAED581),
    greetings: ['흥, 마음에 안 드는 게 있나요?', '싫은 건 싫다고 말해도 돼요.'],
    comfortMessages: ['자신의 취향을 존중하는 건 중요해요.', '불편한 마음은 잠시 내려놓아요.'],
    appearance: CharacterAppearance.spiky,
  ),
  '분노': EmotionCharacter(
    name: '화르륵',
    color: const Color(0xFFD50000), // Intense Red
    accentColor: const Color(0xFFFF8A80),
    greetings: ['으아아! 열정이 넘치는 날이네요!', '화가 날 땐 심호흡을 해봐요.'],
    comfortMessages: ['분노는 변화를 위한 에너지예요.', '뜨거운 마음을 긍정적으로 써봐요.'],
    appearance: CharacterAppearance.spiky,
  ),
  '기대': EmotionCharacter(
    name: '설렘이',
    color: const Color(0xFFFF9800), // Orange
    accentColor: const Color(0xFFFFCC80),
    greetings: ['뭔가 좋은 일이 생길 것 같아요!', '두근두근, 설레는 하루네요.'],
    comfortMessages: ['기다림의 끝엔 행복이 있을 거예요.', '희망을 품고 나아가요.'],
    appearance: CharacterAppearance.cloud,
  ),
  '사랑': EmotionCharacter(
    name: '사랑천사',
    color: const Color(0xFFE91E63), // Hot Pink
    accentColor: const Color(0xFFF48FB1),
    greetings: ['세상은 사랑으로 가득 차 있어요!', '당신을 정말 사랑해요!'],
    comfortMessages: ['사랑은 모든 것을 치유해요.', '따뜻한 마음을 나누는 하루 되세요.'],
    appearance: CharacterAppearance.heart,
  ),
  '낙관': EmotionCharacter(
    name: '희망이',
    color: const Color(0xFFFFC107), // Amber
    accentColor: const Color(0xFFFFE082),
    greetings: ['모든 게 잘 될 거예요!', '긍정의 힘을 믿어요.'],
    comfortMessages: ['밝은 미래가 기다리고 있어요.', '웃으면 복이 와요!'],
    appearance: CharacterAppearance.round,
  ),
  '비관': EmotionCharacter(
    name: '먹구름',
    color: const Color(0xFF9E9E9E), // Grey
    accentColor: const Color(0xFFEEEEEE),
    greetings: ['세상이 조금 어둡게 보이나요?', '가끔은 부정적인 생각도 들 수 있죠.'],
    comfortMessages: ['어둠 속에서도 빛은 존재해요.', '힘든 시간도 결국 지나갈 거예요.'],
    appearance: CharacterAppearance.droplet,
  ),
  // New Characters
  '우호성': EmotionCharacter(
    name: '환대이',
    color: const Color(0xFF87CEEB), // Sky Blue
    accentColor: const Color(0xFFB3E5FC),
    greetings: ['만나서 반가워요! 친하게 지내요.', '당신에게 도움이 되고 싶어요.'],
    comfortMessages: ['함께라면 뭐든 할 수 있어요.', '따뜻한 마음을 나누고 싶어요.'],
    appearance: CharacterAppearance.round,
  ),
  '오만': EmotionCharacter(
    name: '도도이',
    color: const Color(0xFF4B0082), // Indigo
    accentColor: const Color(0xFFB39DDB),
    greetings: ['흥, 나만큼 멋진 사람은 없죠.', '자신감은 나의 무기예요.'],
    comfortMessages: ['가끔은 겸손해질 필요도 있어요.', '당신도 충분히 멋진 사람이에요.'],
    appearance: CharacterAppearance.spiky,
  ),
  '비우호성': EmotionCharacter(
    name: '가시',
    color: const Color(0xFF8B0000), // Dark Blood Red
    accentColor: const Color(0xFFEF9A9A),
    greetings: ['가까이 오지 마세요.', '혼자 있고 싶을 때도 있는 법이죠.'],
    comfortMessages: ['마음의 문을 조금만 열어볼까요?', '진심은 언젠가 통할 거예요.'],
    appearance: CharacterAppearance.spiky,
  ),
  '감사': EmotionCharacter(
    name: '감사요정',
    color: const Color(0xFF2E7D32), // Forest Green
    accentColor: const Color(0xFFA5D6A7),
    greetings: ['모든 것에 감사해요!', '당신 덕분에 행복해요.'],
    comfortMessages: ['작은 것에도 감사하면 행복해져요.', '고마운 마음을 전해봐요.'],
    appearance: CharacterAppearance.round,
  ),
  '겸손': EmotionCharacter(
    name: '차분이',
    color: const Color(0xFF9575CD), // Calm Purple
    accentColor: const Color(0xFFD1C4E9),
    greetings: ['저는 아직 부족한 점이 많아요.', '배우는 자세로 임할게요.'],
    comfortMessages: ['자신을 낮추면 더 많은 것을 볼 수 있어요.', '당신의 겸손함이 빛나요.'],
    appearance: CharacterAppearance.droplet,
  ),
  '후회': EmotionCharacter(
    name: '되감이',
    color: const Color(0xFF4A148C), // Dark Purple
    accentColor: const Color(0xFFCE93D8),
    greetings: ['그때 그러지 말았어야 했는데...', '지난 일이 자꾸 생각나요.'],
    comfortMessages: ['과거는 바꿀 수 없지만 미래는 바꿀 수 있어요.', '실수는 성장의 밑거름이에요.'],
    appearance: CharacterAppearance.droplet,
  ),
  '수치심': EmotionCharacter(
    name: '숨음이',
    color: const Color(0xFFB71C1C), // Dark Red
    accentColor: const Color(0xFFEF9A9A),
    greetings: ['쥐구멍에라도 숨고 싶어요...', '얼굴을 들 수가 없네요.'],
    comfortMessages: ['누구나 실수는 하는 법이에요.', '자신을 너무 자책하지 마세요.'],
    appearance: CharacterAppearance.droplet,
  ),
  '부끄러움': EmotionCharacter(
    name: '수줍이',
    color: const Color(0xFFF8BBD0), // Baby Pink
    accentColor: const Color(0xFFFFCDD2),
    greetings: ['저기... 안녕하세요...', '얼굴이 빨개진 것 같아요.'],
    comfortMessages: ['용기를 내어 말해봐요.', '당신의 수줍은 모습도 매력적이에요.'],
    appearance: CharacterAppearance.cloud,
  ),
};
