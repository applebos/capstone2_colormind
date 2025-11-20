
import 'package:colormind/youtube_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class YouTubeVideoTile extends StatelessWidget {
  final YouTubeVideo video;
  final String emotion;
  const YouTubeVideoTile({
    super.key,
    required this.video,
    required this.emotion,
  });

  Widget _buildThumbnailImage(BuildContext context) {
    const double width = 120;
    const double height = 67.5;
    final Widget errorWidget = SizedBox(
      width: width,
      height: height,
      child: Icon(
        FontAwesomeIcons.youtube,
        color: Theme.of(context).primaryColor, // 주 컬러 푸시아 핑크
      ),
    );

    if (video.thumbnailUrl.isNotEmpty) {
      return Image.network(
        video.thumbnailUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Theme.of(context).scaffoldBackgroundColor, // 네추럴 화이트
        child: errorWidget,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final youtubeService = Provider.of<YouTubeService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          youtubeService.selectVideo(video);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildThumbnailImage(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
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
