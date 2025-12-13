import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Background blur shape for notifications screen
///
/// Renders a positioned blur shape image at the top-left corner
/// of the screen for visual depth.
class NotificationsBackgroundBlur extends StatelessWidget {
  const NotificationsBackgroundBlur({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Positioned(
      left: responsive.scale(-40),
      top: responsive.scale(-100),
      child: Image.asset(
        'assets/images/notifications_alerts_blur_shape.png',
        width: responsive.scale(467.78),
        height: responsive.scale(461.3),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image is missing
          return SizedBox(
            width: responsive.scale(467.78),
            height: responsive.scale(461.3),
          );
        },
      ),
    );
  }
}

