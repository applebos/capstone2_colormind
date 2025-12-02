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
      color: Colors.black, // Always black
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
              backgroundColor: Colors.grey[300], // Light grey background
              valueColor: AlwaysStoppedAnimation<Color>(
                isHighlighted
                    ? Theme.of(context).primaryColor // Highlighted color
                    : Theme.of(context).primaryColor.withOpacity(0.7), // Normal color
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
