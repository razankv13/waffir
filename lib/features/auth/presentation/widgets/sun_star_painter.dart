import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Custom painter for drawing a sun/star burst icon
///
/// Features:
/// - Multiple pointed rays radiating from center
/// - Geometric, clean design
/// - Matches Figma design aesthetic
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   size: Size(60, 60),
///   painter: SunStarPainter(
///     color: Theme.of(context).colorScheme.onSurface,
///   ),
/// )
/// ```
class SunStarPainter extends CustomPainter {
  const SunStarPainter({
    required this.color,
    this.numberOfRays = 16,
  });

  final Color color;
  final int numberOfRays;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.5;

    final path = Path();

    // Create star/sun shape with alternating points
    for (int i = 0; i < numberOfRays * 2; i++) {
      final angle = (i * math.pi) / numberOfRays;
      final radius = i.isEven ? outerRadius : innerRadius;

      final x = center.dx + radius * math.cos(angle - math.pi / 2);
      final y = center.dy + radius * math.sin(angle - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SunStarPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.numberOfRays != numberOfRays;
  }
}
