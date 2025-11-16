import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isWeb = false;

  AudioService() {
    _isWeb = identical(0, 0.0);
  }
  
  Future<void> play(String url) async {
    try {
      if (_isWeb) {
        await _audioPlayer.play(UrlSource(url));
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      print('Error playing audio: $e');
      rethrow;
    }
  }
  
  Future<void> pause() async {
    await _audioPlayer.pause();
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
  }
  
  Future<void> seek(Duration position) async {
    try {
      if (_isWeb) {
        final state = _audioPlayer.state;
        if (state != PlayerState.playing) {
          await _audioPlayer.pause();
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
      
      await _audioPlayer.seek(position);
      
      if (_isWeb) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    } catch (e) {
      print('Error seeking: $e');
      rethrow;
    }
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }
  
  Stream<Duration> get onPositionChanged => _audioPlayer.onPositionChanged;
  Stream<Duration> get onDurationChanged => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged => _audioPlayer.onPlayerStateChanged;
  
  void dispose() {
    _audioPlayer.dispose();
  }
}