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
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tick icon
        Icon(
          Icons.check_circle,
          size: responsive.scale(16),
          color: theme.colorScheme.onSurface,
        ),
        SizedBox(width: responsive.scale(12)),
        // Benefit text
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: responsive.scaleFontSize(14, minSize: 12),
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
