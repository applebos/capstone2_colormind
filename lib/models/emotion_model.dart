import 'package:flutter/material.dart';

enum EmotionSentiment { positive, negative, neutral }

class Emotion {
  final String name;
  final Color backgroundColor;
  final IconData icon;
  final List<String> musicFileNames;
  final String commentKeyword;
  final EmotionSentiment sentiment;
  final double correctionFactor;
  final String playlistId; // Add playlistId field

  const Emotion({
    required this.name,
    required this.backgroundColor,
    required this.icon,
    required this.musicFileNames,
    required this.commentKeyword,
    required this.sentiment,
    this.correctionFactor = 1.0,
    required this.playlistId, // Add playlistId to constructor
  });
}

const List<Emotion> allEmotions = [
  Emotion(
    name: "우호성",
    backgroundColor: Color(0xFF4DD0E1),
    icon: Icons.thumb_up_alt_outlined,
    musicFileNames: [
      "background-delicate-presentation-peaceful-happy-friendly-music-20859.mp3",
    ],
    commentKeyword: "친절함",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTHX3gvDMzH9oMuaqDXrRtqG",
  ),
  Emotion(
    name: "분노",
    backgroundColor: Color(0xFFD50000),
    icon: Icons.local_fire_department_outlined,
    musicFileNames: ["must-be-angry-259502.mp3"],
    commentKeyword: "격정",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTHQkO7luUGvFcsBsgiQbsxR",
  ),
  Emotion(
    name: "기대",
    backgroundColor: Color(0xFFFF9800),
    icon: Icons.hourglass_top_outlined,
    musicFileNames: ["love-romantic-hopeful-music-333017.mp3"],
    commentKeyword: "설렘",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTFNiWKtWMCIwtkXIJQXxDvm",
  ),
  Emotion(
    name: "오만",
    backgroundColor: Color(0xFF4B0082),
    icon: Icons.sentiment_very_dissatisfied,
    musicFileNames: ["dirty-167223.mp3"],
    commentKeyword: "자신감",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTHc8b7cZyo2UqmuKC4-C9Xg",
  ),
  Emotion(
    name: "비우호성",
    backgroundColor: Color(0xFF8B0000),
    icon: Icons.thumb_down_alt_outlined,
    musicFileNames: ["resist-the-zombies-235446.mp3"],
    commentKeyword: "경계심",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTEKbpJ2wO3iAJpCFd26M0aO",
  ),
  Emotion(
    name: "혐오",
    backgroundColor: Color(0xFF4E5B31),
    icon: Icons.sick_outlined,
    musicFileNames: ["horrible-22149.mp3"],
    commentKeyword: "불쾌감",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTEKpLude49BtkFzu3qgdCY9",
  ),
  Emotion(
    name: "두려움",
    backgroundColor: Color(0xFF000000),
    icon: Icons.shield_outlined,
    musicFileNames: ["fear-8019.mp3"],
    commentKeyword: "조심스러움",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTGjDkn-5LXl1s3OmeUuzSLI",
  ),
  Emotion(
    name: "감사",
    backgroundColor: Color(0xFF2E7D32),
    icon: Icons.volunteer_activism_outlined,
    musicFileNames: [
      "miyagisama-thank-you-cinematic-gratitude-determination-9993.mp3",
    ],
    commentKeyword: "고마움",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTF6g77fPKQblaCUqnXp_JVv",
  ),
  Emotion(
    name: "행복",
    backgroundColor: Color(0xFFFFEB3B),
    icon: Icons.sentiment_very_satisfied_outlined,
    musicFileNames: ["happiness-314306.mp3"],
    commentKeyword: "기쁨",
    sentiment: EmotionSentiment.positive,
    correctionFactor: 0.65,
    playlistId: "PL5Is_H8uStTE5myAS0q33SZ325R8KG6Zb",
  ),
  Emotion(
    name: "겸손",
    backgroundColor: Color(0xFF6A0DAD),
    icon: Icons.self_improvement_outlined,
    musicFileNames: ["humble-beginnings-239491.mp3"],
    commentKeyword: "차분함",
    sentiment: EmotionSentiment.neutral,
    correctionFactor: 0.85,
    playlistId: "PL5Is_H8uStTE5myAS0q33SZ325R8KG6Zb",
  ),
  Emotion(
    name: "사랑",
    backgroundColor: Color(0xFFE91E63),
    icon: Icons.favorite_border,
    musicFileNames: ["love-romantic-hopeful-music-333017.mp3"],
    commentKeyword: "애정",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTFMl1BqHZY2tUeqDk-1yjNp",
  ),
  Emotion(
    name: "낙관",
    backgroundColor: Color(0xFFFFC107),
    icon: Icons.wb_sunny_outlined,
    musicFileNames: ["corporate-piano-organic-optimism-220429.mp3"],
    commentKeyword: "희망",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTFBuj7uU-fROEM2FWKcOryr",
  ),
  Emotion(
    name: "비관",
    backgroundColor: Color(0xFF808080),
    icon: Icons.cloud_outlined,
    musicFileNames: ["melancholy-276743.mp3"],
    commentKeyword: "우려",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTGPGAIrwZQLh7xaKI2NvuK",
  ),
  Emotion(
    name: "후회",
    backgroundColor: Color(0xFF5D3FD3),
    icon: Icons.history_outlined,
    musicFileNames: ["regret-sad-dark-piano-solo-music-127988.mp3"],
    commentKeyword: "아쉬움",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTEqOJ5BQI4iqrNCxSOOLT7_",
  ),
  Emotion(
    name: "슬픔",
    backgroundColor: Color(0xFF2196F3),
    icon: Icons.sentiment_dissatisfied_outlined,
    musicFileNames: ["sadness-284119.mp3"],
    commentKeyword: "쓸쓸함",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTGdwY-sGxZSL5WJmQJPpnA-",
  ),
  Emotion(
    name: "수치심",
    backgroundColor: Color(0xFFB71C1C),
    icon: Icons.report_problem_outlined,
    musicFileNames: ["oops-i-said-that-regret-amp-shame-music-314013.mp3"],
    commentKeyword: "부끄러움",
    sentiment: EmotionSentiment.negative,
    playlistId: "PL5Is_H8uStTE3wMVSH2MfpWDvIR4n2mdE",
  ),
  Emotion(
    name: "부끄러움",
    backgroundColor: Color(0xFFF8BBD0),
    icon: Icons.visibility_off_outlined,
    musicFileNames: ["shy-boy-190124.mp3"],
    commentKeyword: "수줍음",
    sentiment: EmotionSentiment.neutral,
    playlistId: "PL5Is_H8uStTHDFftuy0WKo1kq25QWsoYr",
  ),
  Emotion(
    name: "놀람",
    backgroundColor: Color(0xFFFF69B4),
    icon: Icons.flash_on_outlined,
    musicFileNames: ["surprise-celebration-233620.mp3"],
    commentKeyword: "호기심",
    sentiment: EmotionSentiment.neutral,
    correctionFactor: 0.85,
    playlistId: "PL5Is_H8uStTFn2zVJbTlo6Bdo8Fdp_3ug",
  ),
  Emotion(
    name: "신뢰",
    backgroundColor: Color(0xFF1E88E5),
    icon: Icons.verified_user_outlined,
    musicFileNames: ["trust-333601.mp3"],
    commentKeyword: "믿음",
    sentiment: EmotionSentiment.positive,
    playlistId: "PL5Is_H8uStTH6c-Uigi1IZpIRiFuFKCRl",
  ),
];
