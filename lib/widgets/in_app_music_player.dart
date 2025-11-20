import 'package:audioplayers/audioplayers.dart';
import 'package:colormind/music_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'glass_card.dart';
import 'music_tile.dart';

class InAppMusicPlayer extends StatefulWidget {
  final MusicService musicService;
  final List<String> recommendedSongs;

  const InAppMusicPlayer({
    super.key,
    required this.musicService,
    required this.recommendedSongs,
  });

  @override
  State<InAppMusicPlayer> createState() => _InAppMusicPlayerState();
}

class _InAppMusicPlayerState extends State<InAppMusicPlayer> {
  @override
  void initState() {
    super.initState();
    // Listen for music completion to play next song
    widget.musicService.onPlayerComplete.listen((_) {
      _playNext();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _playNext() {
    final currentMusicPath = widget.musicService.currentMusicPath;
    final currentIndex = currentMusicPath != null
        ? widget.recommendedSongs.indexOf(currentMusicPath)
        : -1;
    if (currentIndex != -1 &&
        currentIndex + 1 < widget.recommendedSongs.length) {
      final nextSong = widget.recommendedSongs[currentIndex + 1];
      _handlePlay(nextSong);
    }
  }

  void _handlePlay(String songPath) {
    widget.musicService.playMusic(songPath);
  }

  void _handlePause() {
    widget.musicService.pauseMusic();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final musicService = Provider.of<MusicService>(context);

    if (widget.recommendedSongs.isEmpty) {
      return const GlassCard(child: Center(child: Text('추천 음악을 찾지 못했어요.')));
    }

    final currentSongIndex = musicService.currentMusicPath != null
        ? widget.recommendedSongs.indexOf(musicService.currentMusicPath!)
        : 0;
    final currentSong = widget.recommendedSongs.isNotEmpty
        ? widget.recommendedSongs[currentSongIndex]
        : null;

    if (currentSong == null) {
      return const GlassCard(child: Center(child: Text('재생할 음악이 없습니다.')));
    }

    final nextSongs = widget.recommendedSongs
        .skip(currentSongIndex + 1)
        .take(2)
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '앱에서 바로 듣기',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
            ),
          ),
          Text(
            'From Pixabay',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
            ),
          ),
          const SizedBox(height: 16),
          _buildNowPlaying(currentSong, musicService),
          const SizedBox(height: 16),
          // Music controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  musicService.playerState == PlayerState.playing
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 48,
                  color: Theme.of(context).highlightColor,
                ),
                onPressed: () {
                  if (musicService.playerState == PlayerState.playing) {
                    musicService.pauseMusic();
                  } else {
                    musicService.playMusic(currentSong);
                  }
                },
              ),
            ],
          ),
          // Progress bar
          Slider(
            min: 0.0,
            max: musicService.totalDuration.inMilliseconds.toDouble(),
            value: musicService.currentPosition.inMilliseconds.toDouble(),
            onChanged: (value) {
              musicService.seek(Duration(milliseconds: value.toInt()));
            },
            activeColor: Theme.of(context).highlightColor,
            inactiveColor: Theme.of(
              context,
            ).highlightColor.withAlpha((255 * 0.5).round()), // 주 컬러 푸시아 핑크 50% 투명도
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(musicService.currentPosition)),
                Text(_formatDuration(musicService.totalDuration)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          if (nextSongs.isNotEmpty)
            Text(
              '다음 곡',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color, // 텍스트 딥 블랙
              ),
            ),
          ...nextSongs.map(
            (songPath) => MusicTile(
              songName: songPath.split('/').last.split('.').first,
              isPlaying: false,
              onTap: () => _handlePlay(songPath),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlaying(String songPath, MusicService musicService) {
    final isPlaying =
        musicService.playerState == PlayerState.playing &&
        musicService.currentMusicPath == songPath;
    return MusicTile(
      songName: songPath.split('/').last.split('.').first,
      isPlaying: isPlaying,
      onTap: () {
        if (isPlaying) {
          _handlePause();
        } else {
          _handlePlay(songPath);
        }
      },
    );
  }
}
