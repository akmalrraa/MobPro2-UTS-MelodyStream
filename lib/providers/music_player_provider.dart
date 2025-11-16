import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song_model.dart';
import '../services/audio_service.dart';

enum RepeatMode { none, repeatOne, repeatAll }

class MusicState {
  final List<Song> songs;
  final int currentIndex;
  final PlayerState playerState;
  final Duration position;
  final Duration duration;
  final RepeatMode repeatMode;
  final double volume;
  final bool showVolumeControl;
  final bool isAudioReady;

  const MusicState({
    required this.songs,
    this.currentIndex = 0,
    this.playerState = PlayerState.stopped,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.repeatMode = RepeatMode.none,
    this.volume = 1.0,
    this.showVolumeControl = false,
    this.isAudioReady = false,
  });

  MusicState copyWith({
    List<Song>? songs,
    int? currentIndex,
    PlayerState? playerState,
    Duration? position,
    Duration? duration,
    RepeatMode? repeatMode,
    double? volume,
    bool? showVolumeControl,
    bool? isAudioReady, 
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      currentIndex: currentIndex ?? this.currentIndex,
      playerState: playerState ?? this.playerState,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      repeatMode: repeatMode ?? this.repeatMode,
      volume: volume ?? this.volume,
      showVolumeControl: showVolumeControl ?? this.showVolumeControl,
      isAudioReady: isAudioReady ?? this.isAudioReady,
    );
  }

  Song get currentSong => songs[currentIndex];
}

class MusicPlayerNotifier extends StateNotifier<MusicState> {
  final AudioService _audioService = AudioService();
  bool _isInitialized = false;

  MusicPlayerNotifier() : super(MusicState(songs: songs)) {
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      _setupAudioListeners();
      _isInitialized = true;
      
      state = state.copyWith(isAudioReady: true);
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  void _setupAudioListeners() {
    _audioService.onPositionChanged.listen((position) {
      if (_isInitialized) {
        state = state.copyWith(position: position);
      }
    });

    _audioService.onDurationChanged.listen((duration) {
      if (_isInitialized && duration != Duration.zero) {
        state = state.copyWith(duration: duration, isAudioReady: true);
      }
    });

    _audioService.onPlayerStateChanged.listen((playerState) {
      if (_isInitialized) {
        if (playerState == PlayerState.completed) {
          _handleSongCompletion();
        } else {
          state = state.copyWith(playerState: playerState);
        }
      }
    });
  }

  void _handleSongCompletion() {
    if (!_isInitialized) return;
    
    if (state.repeatMode == RepeatMode.repeatOne) {
      _playCurrentSong();
    } else {
      final nextIndex = (state.currentIndex + 1) % state.songs.length;
      _playSongWithIndex(nextIndex);
    }
  }

  Future<void> _playCurrentSong() async {
    if (!_isInitialized) return;
    
    try {
      await _audioService.stop();
      final song = state.currentSong;
      await _audioService.play(song.assetPath);
      state = state.copyWith(
        playerState: PlayerState.playing,
        position: Duration.zero,
      );
    } catch (e) {
      print('Error replaying song: $e');
      state = state.copyWith(playerState: PlayerState.stopped);
    }
  }

  Future<void> _playSongWithIndex(int index) async {
    if (!_isInitialized || index < 0 || index >= state.songs.length) return;
    
    try {
      await _audioService.stop();
      
      state = state.copyWith(
        currentIndex: index,
        playerState: PlayerState.playing,
        position: Duration.zero,
        duration: Duration.zero, // Reset duration
      );

      final song = state.songs[index];
      await _audioService.play(song.assetPath);
    } catch (e) {
      print('Error playing song: $e');
      state = state.copyWith(playerState: PlayerState.stopped);
    }
  }

  Future<void> play() async {
    if (!_isInitialized || state.playerState == PlayerState.playing) return;
    
    try {
      final song = state.currentSong;
      await _audioService.play(song.assetPath);
      state = state.copyWith(playerState: PlayerState.playing);
    } catch (e) {
      print('Error playing audio: $e');
      state = state.copyWith(playerState: PlayerState.stopped);
    }
  }

  Future<void> pause() async {
    if (!_isInitialized) return;
    
    try {
      await _audioService.pause();
      state = state.copyWith(playerState: PlayerState.paused);
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (!_isInitialized) return;
    
    if (state.playerState == PlayerState.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> playSong(int index) async {
    if (!_isInitialized) return;
    await _playSongWithIndex(index);
  }

  Future<void> next() async {
    if (!_isInitialized) return;
    
    final nextIndex = (state.currentIndex + 1) % state.songs.length;
    await playSong(nextIndex);
  }

  Future<void> previous() async {
    if (!_isInitialized) return;
    
    final prevIndex = state.currentIndex == 0 
        ? state.songs.length - 1 
        : state.currentIndex - 1;
    await playSong(prevIndex);
  }

  void toggleRepeat() {
    if (!_isInitialized) return;
    
    final nextMode = switch (state.repeatMode) {
      RepeatMode.none => RepeatMode.repeatOne,
      RepeatMode.repeatOne => RepeatMode.repeatAll,
      RepeatMode.repeatAll => RepeatMode.none,
    };
    state = state.copyWith(repeatMode: nextMode);
  }

  void setVolume(double volume) {
    if (!_isInitialized) return;
    
    final clampedVolume = volume.clamp(0.0, 1.0);
    state = state.copyWith(volume: clampedVolume);
    _audioService.setVolume(clampedVolume);
  }

  void toggleVolumeControl() {
    if (!_isInitialized) return;
    state = state.copyWith(showVolumeControl: !state.showVolumeControl);
  }

  Future<void> seek(Duration position) async {
    if (!_isInitialized || !state.isAudioReady || state.duration == Duration.zero) {
      print('Audio not ready for seeking');
      return;
    }
    
    try {
      final safePosition = position > state.duration ? state.duration : position;
      await _audioService.seek(safePosition);
      state = state.copyWith(position: safePosition);
    } catch (e) {
      print('Error seeking: $e');
    }
  }

  @override
  void dispose() {
    _isInitialized = false;
    _audioService.dispose();
    super.dispose();
  }
}

final musicPlayerProvider = StateNotifierProvider<MusicPlayerNotifier, MusicState>((ref) {
  return MusicPlayerNotifier();
});