import 'package:flutter/material.dart';
import '../models/emotion_model.dart';
import '../models/emotion_character.dart';
import '../widgets/emotion_character_card.dart';

class DebugCharacterScreen extends StatefulWidget {
  const DebugCharacterScreen({super.key});

  @override
  State<DebugCharacterScreen> createState() => _DebugCharacterScreenState();
}

class _DebugCharacterScreenState extends State<DebugCharacterScreen> {
  String _selectedEmotion = '행복';
  bool _showAccessories = true;

  @override
  Widget build(BuildContext context) {
    final character = EmotionCharacter.fromEmotionName(_selectedEmotion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Characters'),
        actions: [
          IconButton(
            icon: Icon(_showAccessories ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showAccessories = !_showAccessories;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: EmotionCharacterCard(
                character: character,
                emotion: _selectedEmotion,
                size: 250,
                isInteractive: true,
                accessoryEmotions: _showAccessories ? [_selectedEmotion] : [],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: emotion.backgroundColor.withValues(alpha: 0.2),
                      border: Border.all(
                        color: isSelected ? emotion.backgroundColor : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(emotion.icon, color: emotion.backgroundColor),
                        const SizedBox(height: 4),
                        Text(
                          emotion.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
