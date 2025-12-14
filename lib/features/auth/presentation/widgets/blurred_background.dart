import 'package:flutter/material.dart';
import 'package:waffir/core/extensions/context_extensions.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';
import 'package:vector_math/vector_math_64.dart';

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
    final responsive = context.responsive;

    final isRTL = context.locale.languageCode == 'ar';
    return Positioned(
      left: isRTL ? null : -responsive.scaleWithMax(40, max: 60),
      right: isRTL ? -responsive.scaleWithMax(40, max: 60) : null,
      top: -responsive.scaleWithMax(100, max: 140),
      child: Transform(
        alignment: Alignment.center,
        transform: isRTL
            ? Matrix4.identity().scaledByVector3(Vector3(-1.0, 1.0, 1.0))
            : Matrix4.identity(),
        child: Image.asset(
          Assets.images.onboardingShape.path,
          width: responsive.scaleWithMax(467.78, max: 560),
          height: responsive.scaleWithMax(461.3, max: 555),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
