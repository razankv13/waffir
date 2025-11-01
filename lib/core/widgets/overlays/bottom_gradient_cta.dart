import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

/// Bottom gradient overlay with CTA button
///
/// Specifications from Figma:
/// - Height: 215px
/// - Gradient: Linear 180deg from transparent to opaque white
/// - Stops: [0.0, 0.5, 1.0]
/// - Button: "Login to view full deal details" with dark green background
///
/// Used in Stores and Hot Deals screens for encouraging login.
///
/// Example usage:
/// ```dart
/// Positioned(
///   bottom: 88, // Above bottom nav
///   left: 0,
///   right: 0,
///   child: BottomGradientCTA(
///     buttonText: 'Login to view store details',
///     onButtonPressed: () => navigateToLogin(),
///   ),
/// )
/// ```
class BottomGradientCTA extends StatelessWidget {
  const BottomGradientCTA({
    super.key,
    required this.buttonText,
    required this.onButtonPressed,
    this.height = 215,
  });

  final String buttonText;
  final VoidCallback onButtonPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00FFFFFF), // Transparent white (0% opacity)
            Color(0x80FFFFFF), // Semi-transparent white (50% opacity)
            Color(0xFFFFFFFF), // Opaque white (100% opacity)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton.primary(
              onPressed: onButtonPressed,
              text: buttonText,
              width: double.infinity, // Full width
            ),
          ),
          const SizedBox(height: 16), // Bottom spacing
        ],
      ),
    );
  }
}
