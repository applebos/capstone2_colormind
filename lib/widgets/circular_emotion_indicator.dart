import 'package:flutter/material.dart';
import 'package:colormind/models/emotion_model.dart';

class CircularEmotionIndicator extends StatelessWidget {
  final Emotion emotion;
  final double probability;
  final bool isHighlighted;
  final BuildContext context; // Add context here

  const CircularEmotionIndicator({
    super.key,
    required this.emotion,
    required this.probability,
    this.isHighlighted = false,
    required this.context, // Add context to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: 1.0, 
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    emotion.backgroundColor.withOpacity(0.15),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: probability, 
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    emotion.backgroundColor,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              // Icon in the center
              Icon(
                emotion.icon,
                size: 36,
                color: emotion.backgroundColor, 
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          emotion.name,
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: Colors.black, 
            fontSize: 14,
          ),
        ),
        Text(
          '${(probability * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: Colors.black, 
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
