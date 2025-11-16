import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/music_player_provider.dart';

class MusicProgressBar extends ConsumerWidget {
  const MusicProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    final notifier = ref.read(musicPlayerProvider.notifier);

    final position = state.position;
    final duration = state.duration;

    String formatDuration(Duration duration) {
      if (duration == Duration.zero) return "--:--";
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }

    double getProgressValue() {
      if (duration.inSeconds == 0 || !state.isAudioReady) return 0.0;
      return position.inSeconds.toDouble() / duration.inSeconds.toDouble();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AbsorbPointer(
            absorbing: !state.isAudioReady || duration == Duration.zero,
            child: Opacity(
              opacity: state.isAudioReady ? 1.0 : 0.5,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  inactiveTrackColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                  thumbColor: Theme.of(context).colorScheme.primary,
                  overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: getProgressValue(),
                  onChanged: (value) {
                    if (state.isAudioReady && duration != Duration.zero) {
                      final newPosition = Duration(seconds: (value * duration.inSeconds).toInt());
                      notifier.seek(newPosition);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(position),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  formatDuration(duration),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          if (!state.isAudioReady)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Loading audio...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}