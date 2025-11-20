// lib/services/youtube_service.dart

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 사용자님의 emotion_model.dart 파일을 정확하게 import 합니다.
import 'package:colormind/models/emotion_model.dart';

// 여기에 "YouTube Data API v3" 용으로 발급받은 본인의 API 키를 입력하세요.
const String _apiKey =
    'AIzaSyA3txsAitPuGHLOc69bkA_iaQmbvgMwbJQ'; // <--- 반드시 본인의 유효한 키로 교체해주세요.

const String _youtubeApiUrl =
    'https://www.googleapis.com/youtube/v3/playlistItems';

// 유튜브 API 응답을 파싱하기 위한 모델
class YouTubeVideo {
  final String title;
  final String thumbnailUrl;
  final String videoId;

  YouTubeVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      videoId: json['snippet']?['resourceId']?['videoId'] ?? '',
      title: json['snippet']?['title'] ?? '제목 없음',
      thumbnailUrl: json['snippet']?['thumbnails']?['high']?['url'] ?? '',
    );
  }
}

class YouTubeService extends ChangeNotifier {
  final Dio _dio = Dio();
  YoutubePlayerController? _controller;
  YouTubeVideo? _selectedVideo;
  final Map<String, List<YouTubeVideo>> _recommendationsByEmotion = {};

  bool _isPlayerVisible = false;
  bool _isLoadingForEmotion = false;

  YoutubePlayerController? get controller => _controller;

  YouTubeVideo? get selectedVideo => _selectedVideo;

  Map<String, List<YouTubeVideo>> get recommendationsByEmotion =>
      _recommendationsByEmotion;

  bool get isPlayerVisible => _isPlayerVisible;

  bool get isLoading => _isLoadingForEmotion;

  Future<void> fetchVideosForEmotion(String emotionName) async {
    // 이미 로딩했거나 API 키가 설정되지 않았으면 실행 중단
    if (_recommendationsByEmotion.containsKey(emotionName) ||
        _apiKey.startsWith('YOUR')) {
      if (!_recommendationsByEmotion.containsKey(emotionName)) {
        _recommendationsByEmotion[emotionName] = [];
        notifyListeners();
      }
      return;
    }

    _isLoadingForEmotion = true;
    notifyListeners();

    try {
      // 사용자님의 allEmotions 리스트에서 감정 이름으로 playlistId를 정확하게 찾아냅니다.
      final emotion = allEmotions.firstWhere(
        (e) => e.name == emotionName,
        // 혹시 일치하는 감정이 없으면 첫 번째 감정을 기본값으로 사용 (오류 방지)
        orElse: () => allEmotions.first,
      );
      final playlistId = emotion.playlistId;

      if (playlistId.isEmpty) {
        throw Exception(
          "Playlist ID for '$emotionName' is not defined in emotion_model.dart",
        );
      }

      final response = await _dio.get(
        _youtubeApiUrl,
        queryParameters: {
          'part': 'snippet',
          'playlistId': playlistId,
          'maxResults': 10, // 가져올 영상 개수
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200 && response.data['items'] is List) {
        final results = response.data['items'] as List;
        _recommendationsByEmotion[emotionName] = results
            .map((json) => YouTubeVideo.fromJson(json))
            .where((video) => video.videoId.isNotEmpty) // ID가 없는 영상은 제외
            .toList();
      } else {
        _recommendationsByEmotion[emotionName] = [];
      }
    } on DioException catch (e) {
      debugPrint(
        'YouTube API DioException for emotion "$emotionName": ${e.response?.data}',
      );
      _recommendationsByEmotion[emotionName] = [];
    } catch (e) {
      debugPrint(
        'General error fetching videos for emotion "$emotionName": $e',
      );
      _recommendationsByEmotion[emotionName] = [];
    } finally {
      _isLoadingForEmotion = false;
      notifyListeners();
    }
  }

  void selectVideo(YouTubeVideo video) {
    if (_selectedVideo?.videoId == video.videoId && _isPlayerVisible) return;

    _controller?.dispose(); // 이전 컨트롤러가 있다면 안전하게 제거

    _controller = YoutubePlayerController(
      initialVideoId: video.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
      ),
    );
    _selectedVideo = video;
    _isPlayerVisible = true;
    notifyListeners();
  }

  void hidePlayer() {
    if (!_isPlayerVisible) return;
    _isPlayerVisible = false;
    _controller?.pause();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}