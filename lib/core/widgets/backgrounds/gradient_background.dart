import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_colors.dart';

/// Gradient background widget matching Waffir design system
///
/// Creates gradient backgrounds with optional decorative elements
/// as seen in the Figma designs.
///
/// Example:
/// ```dart
/// GradientBackground(
///   type: GradientType.greenToWhite,
///   child: YourContent(),
/// )
/// ```
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.type = GradientType.greenToWhite,
    this.showDecorations = true,
  });

  final Widget child;
  final GradientType type;
  final bool showDecorations;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getGradient(),
      ),
      child: Stack(
        children: [
          // Decorative elements (if enabled)
          if (showDecorations) _buildDecorations(),

          // Main content
          child,
        ],
      ),
    );
  }

  LinearGradient _getGradient() {
    switch (type) {
      case GradientType.greenToWhite:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00FF88), // Green wafir
            Color(0xFFCCFFEE), // Light green
            Color(0xFFFFFFFF), // White
          ],
          stops: [0.0, 0.3, 0.7],
        );
      case GradientType.blueWaffir:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        );
      case GradientType.solid:
        return const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
          ],
        );
      case GradientType.solidBlue:
        return const LinearGradient(
          colors: [
            AppColors.primaryColorDark, // Blue wafir
            AppColors.primaryColorDark,
          ],
        );
    }
  }

  Widget _buildDecorations() {
    // Decorative patterns based on the type
    switch (type) {
      case GradientType.greenToWhite:
        return Positioned.fill(
          child: CustomPaint(
            painter: _GreenDecorationPainter(),
          ),
        );
      case GradientType.blueWaffir:
      case GradientType.solidBlue:
        return Positioned.fill(
          child: CustomPaint(
            painter: _BlueDecorationPainter(),
          ),
        );
      case GradientType.solid:
        return const SizedBox.shrink();
    }
  }
}

/// Types of gradient backgrounds
enum GradientType {
  /// Green to white gradient (used in city selection, etc.)
  greenToWhite,

  /// Blue waffir gradient (used in auth screens)
  blueWaffir,

  /// Solid white background
  solid,

  /// Solid blue background (splash screen)
  solidBlue,
}

/// Custom painter for green gradient decorations
class _GreenDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Add subtle decorative circles
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.1),
      60,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.3),
      40,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for blue gradient decorations
class _BlueDecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Add subtle decorative elements matching Figma pattern
    // Repeating sunburst-like patterns
    for (var i = 0; i < 9; i++) {
      final x = (size.width * (i + 1) / 10) - (size.width * 0.5);
      final y = -size.height * 0.2;

      _drawSunburst(canvas, Offset(x, y), 70, paint);
    }
  }

  void _drawSunburst(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw radiating lines (simplified sunburst effect)
    const rayCount = 20;
    for (var i = 0; i < rayCount; i++) {
      final angle = (i * 2 * 3.14159) / rayCount;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + radius * 0.7 * (i % 2 == 0 ? 1 : 0.5) * (angle % 2),
          center.dy + radius * 0.7 * (i % 2 == 0 ? 1 : 0.5) * (angle % 2),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
