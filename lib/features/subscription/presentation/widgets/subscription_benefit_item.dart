import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// A subscription benefit list item with tick icon and text
///
/// Used to display benefits like "Cancel anytime", "Daily verified discounts", etc.
///
/// Example:
/// ```dart
/// SubscriptionBenefitItem(
///   text: 'Cancel anytime',
/// )
/// ```
class SubscriptionBenefitItem extends StatelessWidget {
  const SubscriptionBenefitItem({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tick icon
        Icon(
          Icons.check_circle,
          size: responsive.s(16),
          color: const Color(0xFF00D9A3), // Bright green from design
        ),
        SizedBox(width: responsive.s(8)), // Reduced spacing from 12 to 8
        // Benefit text
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: responsive.sFont(13, minSize: 11), // Slightly smaller
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
