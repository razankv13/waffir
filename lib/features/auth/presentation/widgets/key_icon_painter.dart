import 'package:flutter/material.dart';

/// Custom painter for drawing a stylized key icon
///
/// Matches the Figma design with:
/// - Circular head with center hole
/// - Diagonal shaft extending up-right
/// - Clean, geometric design
///
/// Example usage:
/// ```dart
/// CustomPaint(
///   size: Size(120, 120),
///   painter: KeyIconPainter(
///     color: Theme.of(context).colorScheme.onSurface,
///   ),
/// )
/// ```
class KeyIconPainter extends CustomPainter {
  const KeyIconPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final keySize = size.width * 0.8; // 80% of available size

    // Key head (circular part) - positioned at bottom-left
    final headRadius = keySize * 0.15;
    final headCenter = Offset(
      center.dx - keySize * 0.15,
      center.dy + keySize * 0.15,
    );

    // Draw outer circle of key head
    canvas.drawCircle(headCenter, headRadius, paint);

    // Draw inner hole (cutout)
    final holePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.clear;
    canvas.drawCircle(headCenter, headRadius * 0.4, holePaint);

    // Key shaft (rectangular diagonal part)
    final shaftWidth = keySize * 0.08;
    final shaftLength = keySize * 0.6;

    // Rotate 45 degrees for diagonal effect
    final angle = -0.785398; // -45 degrees in radians

    canvas.save();
    canvas.translate(headCenter.dx, headCenter.dy);
    canvas.rotate(angle);

    // Draw shaft
    final shaftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        -shaftWidth / 2,
        -headRadius * 0.7,
        shaftWidth,
        -shaftLength,
      ),
      Radius.circular(shaftWidth / 2),
    );
    canvas.drawRRect(shaftRect, paint);

    // Draw teeth (small rectangles at the end of shaft)
    final tooth1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        shaftWidth / 2,
        -shaftLength - headRadius * 0.5,
        shaftWidth * 0.8,
        shaftWidth * 1.5,
      ),
      Radius.circular(shaftWidth * 0.2),
    );
    canvas.drawRRect(tooth1, paint);

    final tooth2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        shaftWidth / 2,
        -shaftLength + headRadius * 0.2,
        shaftWidth * 0.6,
        shaftWidth * 1.2,
      ),
      Radius.circular(shaftWidth * 0.2),
    );
    canvas.drawRRect(tooth2, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(KeyIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
