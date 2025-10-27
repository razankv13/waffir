import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated radial gradient background with starburst effect
///
/// Features:
/// - Vibrant green radial gradient
/// - Animated rotating rays
/// - Smooth continuous animation
/// - Performance optimized with RepaintBoundary
///
/// Example usage:
/// ```dart
/// Scaffold(
///   body: Stack(
///     children: [
///       RadialStarburstBackground(),
///       // Your content here
///     ],
///   ),
/// )
/// ```
class RadialStarburstBackground extends StatefulWidget {
  const RadialStarburstBackground({
    super.key,
    this.duration = const Duration(seconds: 12),
  });

  final Duration duration;

  @override
  State<RadialStarburstBackground> createState() => _RadialStarburstBackgroundState();
}

class _RadialStarburstBackgroundState extends State<RadialStarburstBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _StarburstBackgroundPainter(
              animationValue: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

/// Custom painter for the animated starburst background
class _StarburstBackgroundPainter extends CustomPainter {
  const _StarburstBackgroundPainter({
    required this.animationValue,
  });

  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.25);

    // Draw radial gradient background
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00FF88), // Bright mint green
          const Color(0xFF00E57D), // Medium green
          const Color(0xFF00D9A3), // Primary green
          const Color(0xFFE8F9F3), // Very light green/white
        ],
        stops: const [0.0, 0.3, 0.5, 1.0],
        center: Alignment.center,
      ).createShader(Rect.fromCircle(
        center: center,
        radius: size.width * 0.8,
      ));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );

    // Draw animated rays
    _drawRays(canvas, center, size);
  }

  void _drawRays(Canvas canvas, Offset center, Size size) {
    final rayPaint = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.15)
      ..style = PaintingStyle.fill;

    const numberOfRays = 24;
    final rotationAngle = animationValue * 2 * math.pi;

    for (int i = 0; i < numberOfRays; i++) {
      final angle = (i * 2 * math.pi / numberOfRays) + rotationAngle;

      // Create triangular ray shape
      final path = Path();
      path.moveTo(center.dx, center.dy);

      // Ray extends outward
      final rayLength = size.width * 0.6;
      final rayWidth = size.width * 0.08;

      // Left edge of ray
      final leftX = center.dx + rayLength * math.cos(angle - 0.1);
      final leftY = center.dy + rayLength * math.sin(angle - 0.1);
      path.lineTo(leftX, leftY);

      // Tip of ray (furthest point)
      final tipX = center.dx + (rayLength + rayWidth) * math.cos(angle);
      final tipY = center.dy + (rayLength + rayWidth) * math.sin(angle);
      path.lineTo(tipX, tipY);

      // Right edge of ray
      final rightX = center.dx + rayLength * math.cos(angle + 0.1);
      final rightY = center.dy + rayLength * math.sin(angle + 0.1);
      path.lineTo(rightX, rightY);

      path.close();

      // Vary opacity for alternating rays
      final opacity = i.isEven ? 0.15 : 0.08;
      rayPaint.color = const Color(0xFF00FF88).withOpacity(opacity);

      canvas.drawPath(path, rayPaint);
    }
  }

  @override
  bool shouldRepaint(_StarburstBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
