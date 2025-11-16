import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/music_player_provider.dart';
import '../providers/theme_provider.dart';

class PlayPauseButton extends ConsumerWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    final notifier = ref.read(musicPlayerProvider.notifier);
    final themeState = ref.watch(themeProvider);

    final isPlaying = state.playerState == PlayerState.playing;
    final gradientColors = AppThemes.getThemeGradient(themeState.currentTheme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(isPlaying ? 0.5 : 0.3),
            blurRadius: isPlaying ? 15 : 10,
            spreadRadius: isPlaying ? 2 : 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 28,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            key: ValueKey(isPlaying),
            color: Colors.white,
          ),
        ),
        onPressed: () {
          notifier.togglePlayPause();
        },
      ),
    );
  }
}