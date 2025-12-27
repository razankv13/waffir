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
    final responsive = ResponsiveHelper.of(context);

    return Positioned(
      left: responsive.s(-40),
      top: responsive.s(-100),
      child: Image.asset(
        'assets/images/notifications_alerts_blur_shape.png',
        width: responsive.s(467.78),
        height: responsive.s(461.3),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image is missing
          return SizedBox(
            width: responsive.s(467.78),
            height: responsive.s(461.3),
          );
        },
      ),
    );
  }
}

