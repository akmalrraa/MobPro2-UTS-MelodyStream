import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/providers/music_player_provider.dart';

class MusicParticles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    final isPlaying = state.playerState == PlayerState.playing;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: List.generate(15, (index) {
            return Positioned(
              left: Random().nextDouble() * constraints.maxWidth,
              top: Random().nextDouble() * constraints.maxHeight,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 800),
                width: isPlaying ? Random().nextDouble() * 8 + 2 : 0,
                height: isPlaying ? Random().nextDouble() * 8 + 2 : 0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}