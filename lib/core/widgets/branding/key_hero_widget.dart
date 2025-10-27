import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Key Hero Widget with radial gradient and animation
///
/// Features:
/// - Custom painted key icon with dark navy color
/// - Radial gradient background (mint green to white)
/// - Sunburst rays effect
/// - Subtle pulsing animation
/// - Responsive sizing
///
/// Example usage:
/// ```dart
/// KeyHeroWidget(
///   size: 350,
/// )
/// ```
class KeyHeroWidget extends StatefulWidget {
  const KeyHeroWidget({
    super.key,
    this.size = 350.0,
  });

  final double size;

  @override
  State<KeyHeroWidget> createState() => _KeyHeroWidgetState();
}

class _KeyHeroWidgetState extends State<KeyHeroWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: CustomPaint(
                painter: _KeyHeroPainter(
                  primaryColor: Theme.of(context).colorScheme.primary,
                ),
                size: Size(widget.size, widget.size),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for the key hero with radial gradient and sunburst
class _KeyHeroPainter extends CustomPainter {
  _KeyHeroPainter({required this.primaryColor});

  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw radial gradient background
    _drawRadialGradient(canvas, size, center);

    // Draw sunburst rays
    _drawSunburstRays(canvas, size, center);

    // Draw key icon
    _drawKeyIcon(canvas, size, center);
  }

  void _drawRadialGradient(Canvas canvas, Size size, Offset center) {
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.3),
          primaryColor.withValues(alpha: 0.15),
          primaryColor.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));

    canvas.drawCircle(center, size.width / 2, gradientPaint);
  }

  void _drawSunburstRays(Canvas canvas, Size size, Offset center) {
    const rayCount = 24;
    final rayPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final path = Path();

      // Create triangular rays
      final rayLength = size.width * 0.45;
      final rayWidth = 8.0;

      path.moveTo(center.dx, center.dy);
      path.lineTo(
        center.dx + (rayLength * math.cos(angle - 0.05)),
        center.dy + (rayLength * math.sin(angle - 0.05)),
      );
      path.lineTo(
        center.dx + (rayLength * math.cos(angle + 0.05)),
        center.dy + (rayLength * math.sin(angle + 0.05)),
      );
      path.close();

      canvas.drawPath(path, rayPaint);
    }
  }

  void _drawKeyIcon(Canvas canvas, Size size, Offset center) {
    final keyPaint = Paint()
      ..color = const Color(0xFF1F2937) // Dark navy
      ..style = PaintingStyle.fill;

    final keySize = size.width * 0.35;

    // Save canvas state
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // Rotate key to match the Figma design (tilted)
    canvas.rotate(-math.pi / 4.5);

    // Draw key shaft (the long part)
    final shaftRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(keySize * 0.15, 0),
        width: keySize * 0.7,
        height: keySize * 0.15,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(shaftRect, keyPaint);

    // Draw key head (circular part)
    canvas.drawCircle(
      Offset(-keySize * 0.2, 0),
      keySize * 0.2,
      keyPaint,
    );

    // Draw inner circle of key head
    final innerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(-keySize * 0.2, 0),
      keySize * 0.1,
      innerCirclePaint,
    );

    // Draw key teeth (the notches at the end)
    final teethPath = Path();

    // First tooth
    teethPath.addRect(
      Rect.fromLTWH(
        keySize * 0.4,
        -keySize * 0.075,
        keySize * 0.08,
        keySize * 0.08,
      ),
    );

    // Second tooth
    teethPath.addRect(
      Rect.fromLTWH(
        keySize * 0.45,
        keySize * 0.075,
        keySize * 0.08,
        keySize * 0.08,
      ),
    );

    canvas.drawPath(teethPath, keyPaint);

    // Draw the small sun/star at the top (like in Figma)
    canvas.restore();
    _drawSunIcon(canvas, center, keySize);
  }

  void _drawSunIcon(Canvas canvas, Offset center, double keySize) {
    final sunPaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.fill;

    final sunCenter = Offset(
      center.dx + keySize * 0.35,
      center.dy - keySize * 0.35,
    );

    // Draw sun rays
    const rayCount = 16;
    for (var i = 0; i < rayCount; i++) {
      final angle = (i * 2 * math.pi) / rayCount;
      final rayLength = keySize * 0.08;
      final rayWidth = 3.0;

      final path = Path();
      path.moveTo(sunCenter.dx, sunCenter.dy);
      path.lineTo(
        sunCenter.dx + (rayLength * math.cos(angle)),
        sunCenter.dy + (rayLength * math.sin(angle)),
      );

      canvas.drawPath(
        path,
        sunPaint..strokeWidth = rayWidth..style = PaintingStyle.stroke,
      );
    }

    // Draw sun circle
    canvas.drawCircle(sunCenter, keySize * 0.04, sunPaint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
