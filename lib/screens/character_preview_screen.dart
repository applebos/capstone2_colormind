import 'package:flutter/material.dart';
import '../models/emotion_model.dart';
import '../models/emotion_character.dart';
import '../widgets/emotion_character_card.dart';

class CharacterPreviewScreen extends StatefulWidget {
  const CharacterPreviewScreen({super.key});

  @override
  State<CharacterPreviewScreen> createState() => _CharacterPreviewScreenState();
}

class _CharacterPreviewScreenState extends State<CharacterPreviewScreen> {
  String _selectedEmotion = '행복';
  final List<String> _selectedAccessories = [];

  @override
  Widget build(BuildContext context) {
    final character = EmotionCharacter.fromEmotionName(_selectedEmotion);

    final emotionColor = allEmotions.firstWhere((e) => e.name == _selectedEmotion).backgroundColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              emotionColor.withValues(alpha: 0.8),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '캐릭터 프리뷰',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Character Preview Area
              Expanded(
                flex: 4,
                child: Center(
                  child: EmotionCharacterCard(
                    character: character,
                    emotion: _selectedEmotion,
                    size: 250,
                    isInteractive: true,
                    accessoryEmotions: _selectedAccessories,
                  ),
                ),
              ),

              // Controls
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: const Color(0xFF333333),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: emotionColor,
                          tabs: const [
                            Tab(text: '메인 캐릭터'),
                            Tab(text: '악세사리'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Main Character Selection
                              GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: allEmotions.length,
                                itemBuilder: (context, index) {
                                  final emotion = allEmotions[index];
                                  final isSelected = emotion.name == _selectedEmotion;
                                  
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedEmotion = emotion.name;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: emotion.backgroundColor.withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(color: emotion.backgroundColor, width: 3)
                                                : null,
                                          ),
                                          child: Icon(
                                            emotion.icon,
                                            color: isSelected ? emotion.backgroundColor : const Color(0xFF666666),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          emotion.name,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF333333),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Accessory Selection
                              GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: allEmotions.length,
                                itemBuilder: (context, index) {
                                  final emotion = allEmotions[index];
                                  final isSelected = _selectedAccessories.contains(emotion.name);
                                  
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedAccessories.remove(emotion.name);
                                        } else {
                                          _selectedAccessories.add(emotion.name);
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? emotion.backgroundColor.withValues(alpha: 0.5)
                                                : emotion.backgroundColor.withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(color: emotion.backgroundColor, width: 3)
                                                : null,
                                          ),
                                          child: Icon(
                                            emotion.icon, 
                                            color: isSelected ? Colors.white : const Color(0xFF666666),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          emotion.name,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF333333),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
