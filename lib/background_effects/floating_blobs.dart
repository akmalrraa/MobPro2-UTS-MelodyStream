import 'dart:math';

import 'package:flutter/material.dart';

class FloatingBlobs extends StatefulWidget {
  @override
  _FloatingBlobsState createState() => _FloatingBlobsState();
}

class _FloatingBlobsState extends State<FloatingBlobs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<BlobData> _blobs;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);
    
    _blobs = [
      BlobData(offset: Offset(0.2, 0.3), size: 120, color: Colors.blue.withOpacity(0.1)),
      BlobData(offset: Offset(0.7, 0.1), size: 80, color: Colors.purple.withOpacity(0.08)),
      BlobData(offset: Offset(0.1, 0.7), size: 100, color: Colors.pink.withOpacity(0.06)),
      BlobData(offset: Offset(0.8, 0.6), size: 60, color: Colors.green.withOpacity(0.05)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: _blobs.asMap().entries.map((entry) {
            final index = entry.key;
            final blob = entry.value;
            final animation = CurvedAnimation(
              parent: _controller,
              curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
            );
            
            return Positioned(
              left: MediaQuery.of(context).size.width * blob.offset.dx + 
                   sin(animation.value * 2 * pi) * 20,
              top: MediaQuery.of(context).size.height * blob.offset.dy + 
                  cos(animation.value * 2 * pi) * 15,
              child: Container(
                width: blob.size + sin(animation.value * pi) * 10,
                height: blob.size + cos(animation.value * pi) * 10,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [blob.color, blob.color.withOpacity(0.3)],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class BlobData {
  final Offset offset;
  final double size;
  final Color color;

  BlobData({required this.offset, required this.size, required this.color});
}