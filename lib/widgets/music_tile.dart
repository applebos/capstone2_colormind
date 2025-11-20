import 'package:flutter/material.dart';

class MusicTile extends StatelessWidget {
  final String songName;
  final bool isPlaying;
  final VoidCallback onTap;

  const MusicTile({
    super.key,
    required this.songName,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 40,
              color: Theme.of(context).highlightColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                songName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
