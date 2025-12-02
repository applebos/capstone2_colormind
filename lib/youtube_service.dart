
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart';

// 사용자님의 emotion_model.dart 파일을 정확하게 import 합니다.
import 'package:colormind/models/emotion_model.dart';

// =================================================================================
// 보안 경고: API 키를 소스 코드에 직접 포함하는 것은 매우 위험합니다.
// 앱이 디컴파일되면 키가 유출되어 무단으로 사용될 수 있습니다.
//
// 추천 해결 방법:
// 1. 프로젝트 루트에 `.env` 파일을 생성합니다:
//    YOUTUBE_API_KEY=AIzaSy... (본인의 전체 API 키)
//
// 2. `pubspec.yaml` 파일에 `flutter_dotenv` 패키지를 추가합니다.
//    dependencies:
//      flutter_dotenv: ^5.1.0
//
// 3. `.gitignore` 파일에 `.env`를 추가하여 키가 Git에 커밋되지 않도록 합니다.
//
// 4. main.dart에서 앱 시작 시 `await dotenv.load(fileName: ".env");`를 호출합니다.
//
// 5. 아래 코드를 `final String _apiKey = dotenv.env['YOUTUBE_API_KEY'] ?? '';` 와 같이 수정합니다.
// =================================================================================
const String _apiKey = 'Youtube API'; // <--- 본인의 유효한 키로 교체해주세요.

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
  String? _errorMessage;

  YoutubePlayerController? get controller => _controller;
  YouTubeVideo? get selectedVideo => _selectedVideo;
  Map<String, List<YouTubeVideo>> get recommendationsByEmotion =>
      _recommendationsByEmotion;
  bool get isPlayerVisible => _isPlayerVisible;
  bool get isLoading => _isLoadingForEmotion;
  String? get errorMessage => _errorMessage;

  // Player listener to detect and log errors
  void _playerListener() {
    if (_controller != null && _controller!.value.errorCode != 0) {
      final errorCode = _controller!.value.errorCode;
      // This debugPrint is crucial for diagnosing the issue.
      // Common Error Codes:
      // 2: Invalid video ID.
      // 5: An error in the HTML5 player.
      // 100: Video not found.
      // 101, 150: Embedding disabled by the video owner OR API key restriction.
      debugPrint("YouTube Player Error: $errorCode. (Most likely 101 or 150, indicating an API key SHA-1 fingerprint issue on release builds).");
      _errorMessage = "영상을 재생할 수 없습니다 (오류 코드: $errorCode). 다른 영상을 선택해주세요.";
      notifyListeners();
    }
  }

  Future<void> fetchVideosForEmotion(String emotionName) async {
    if (_recommendationsByEmotion.containsKey(emotionName)) {
      return;
    }
    if (_apiKey.isEmpty || _apiKey == 'youtube api') {
      _errorMessage = 'YouTube API 키가 유효하지 않습니다.\n개발자에게 문의해주세요.';
      _recommendationsByEmotion[emotionName] = [];
      notifyListeners();
      return;
    }

    _isLoadingForEmotion = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final emotion = allEmotions.firstWhere(
            (e) => e.name == emotionName,
        orElse: () => throw Exception("Cannot find emotion: $emotionName"),
      );
      final playlistId = emotion.playlistId;

      if (playlistId.isEmpty) {
        throw Exception(
            "Playlist ID for '$emotionName' is not defined in emotion_model.dart");
      }

      final response = await _dio.get(
        _youtubeApiUrl,
        queryParameters: {
          'part': 'snippet',
          'playlistId': playlistId,
          'maxResults': 10,
          'key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        if (response.data?['items'] is List) {
          final results = response.data['items'] as List;
          _recommendationsByEmotion[emotionName] = results
              .map((json) => YouTubeVideo.fromJson(json))
              .where((video) => video.videoId.isNotEmpty)
              .toList();
        } else {
          final error = response.data?['error']?['message'] ?? 'Unknown API error';
          throw Exception('API Error: $error');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('YouTube API DioException for emotion "$emotionName": ${e.response?.data}');
      _errorMessage = '영상을 불러오는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 API키를 확인해주세요.';
      _recommendationsByEmotion[emotionName] = [];
    } catch (e) {
      debugPrint('General error fetching videos for emotion "$emotionName": $e');
      _errorMessage = '오류: ${e.toString().replaceAll("Exception: ", "")}';
      _recommendationsByEmotion[emotionName] = [];
    } finally {
      _isLoadingForEmotion = false;
      notifyListeners();
    }
  }

  void selectVideo(YouTubeVideo video) {
    if (_selectedVideo?.videoId == video.videoId && _isPlayerVisible) return;

    _controller?.removeListener(_playerListener);
    _controller?.dispose();

    _controller = YoutubePlayerController(
      initialVideoId: video.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(_playerListener); // Add listener back

    _selectedVideo = video;
    _isPlayerVisible = true;
    _errorMessage = null; // Clear previous errors on new selection
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
    _controller?.removeListener(_playerListener);
    _controller?.dispose();
    super.dispose();
  }
}
