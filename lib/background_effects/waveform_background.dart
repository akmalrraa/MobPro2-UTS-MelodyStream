import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/providers/music_player_provider.dart';

class WaveformBackground extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicPlayerProvider);
    
    return CustomPaint(
      painter: WaveformPainter(
        isPlaying: state.playerState == PlayerState.playing,
        theme: Theme.of(context).colorScheme,
      ),
      size: Size.infinite,
    );
  }
}

class WaveformPainter extends CustomPainter {
  final bool isPlaying;
  final ColorScheme theme;

  WaveformPainter({required this.isPlaying, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.primary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final amplitude = isPlaying ? 30.0 : 10.0;
    
    path.moveTo(0, size.height / 2);
    
    for (double x = 0; x < size.width; x += 5) {
      final y = size.height / 2 + 
                sin(x * 0.02 + DateTime.now().millisecondsSinceEpoch * 0.001) * 
                amplitude;
      path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => true;
}