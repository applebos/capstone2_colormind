import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class MusicService with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  String? _currentMusicPath;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  MusicService() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _playerState = PlayerState.stopped;
      _currentPosition = Duration.zero;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });
  }

  PlayerState get playerState => _playerState;
  String? get currentMusicPath => _currentMusicPath;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;
  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;

  Future<void> playMusic(String assetPath) async {
    if (_currentMusicPath == assetPath && _playerState == PlayerState.paused) {
      await _audioPlayer.resume();
    } else {
      _currentMusicPath = assetPath;
      await _audioPlayer.play(AssetSource(assetPath));
    }
    notifyListeners();
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
    notifyListeners();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    notifyListeners();
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    _currentMusicPath = null;
    _currentPosition = Duration.zero;
    _totalDuration = Duration.zero;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}