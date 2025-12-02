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
          width: 80, // Size of the circular indicator
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: 1.0, // Full circle for background
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round, // Rounded ends for 3D effect
                  valueColor: AlwaysStoppedAnimation<Color>(
                    emotion.backgroundColor.withOpacity(0.15),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              // Progress circle
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: probability, // Filled based on probability
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round, // Rounded ends for 3D effect
                  valueColor: AlwaysStoppedAnimation<Color>(
                    emotion.backgroundColor, // Emotion's background color for progress
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              // Icon in the center
              Icon(
                emotion.icon,
                size: 36,
                color: emotion.backgroundColor, // Using emotion color for the icon
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          emotion.name,
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: Colors.black, // Always black
            fontSize: 14,
          ),
        ),
        Text(
          '${(probability * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: Colors.black, // Always black
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
