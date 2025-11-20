
import 'package:flutter/material.dart';

class EmotionIndicator extends StatelessWidget {
  final String emotion;
  final double probability;
  final bool isHighlighted;
  final BuildContext context; // Add context here

  const EmotionIndicator({
    super.key,
    required this.emotion,
    required this.probability,
    this.isHighlighted = false,
    required this.context, // Add context to constructor
  });

  TextStyle _getTextStyle() {
    return TextStyle(
      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
      color: isHighlighted ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).textTheme.bodyMedium?.color?.withAlpha((255 * 0.7).round()), // 텍스트 딥 블랙
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              emotion,
              style: _getTextStyle(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LinearProgressIndicator(
              value: probability,
              minHeight: 10,
              backgroundColor: Theme.of(context).dividerColor, // 네추럴 화이트
              valueColor: AlwaysStoppedAnimation<Color>(
                isHighlighted
                    ? Theme.of(context).primaryColor // 보조2 청록
                    : Theme.of(context).primaryColor.withAlpha((255 * 0.7).round()), // 보조2 청록 70% 투명도
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              '${(probability * 100).toStringAsFixed(1)}%',
              style: _getTextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
