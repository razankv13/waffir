import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Blurred background for phone login screen matching Figma design
///
/// Features:
/// - White background
/// - Blurred shape positioned at (-40, -100)
/// - 100px blur effect
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     const Positioned.fill(child: BlurredBackground()),
///     // Your content
///   ],
/// )
/// ```
class BlurredBackground extends StatelessWidget {
  const BlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF), // Pure white background per Figma
      child: Stack(
        children: [
          // Blurred shape positioned at (-40, -100) per Figma spec
          Positioned(
            left: -40,
            top: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 100,
                sigmaY: 100,
                tileMode: TileMode.decal,
              ),
              child: Image.asset(
                Assets.images.loginBlurShape.path,
                width: 467.78,
                height: 461.3,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
