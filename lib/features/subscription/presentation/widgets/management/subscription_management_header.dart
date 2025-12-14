import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

class SubscriptionManagementHeader extends StatelessWidget {
  const SubscriptionManagementHeader({super.key, required this.selectedPeriod});

  final SubscriptionPeriod selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'You just got \"One\" month free',
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            fontSize: responsive.scaleFontSize(18, minSize: 16),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        SizedBox(height: responsive.scale(16)),
        SizedBox(
          width: selectedPeriod == SubscriptionPeriod.monthly
              ? responsive.scale(243)
              : responsive.scale(323),
          child: Text(
            'Continue to start your free month and confirm your plan.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: responsive.scaleFontSize(16, minSize: 14),
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, duration: 400.ms);
  }
}
