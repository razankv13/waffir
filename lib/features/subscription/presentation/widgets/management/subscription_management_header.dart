import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

class SubscriptionManagementHeader extends StatelessWidget {
  const SubscriptionManagementHeader({super.key, required this.selectedPeriod});

  final SubscriptionPeriod selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          LocaleKeys.subscription.management.title.tr(),
          textAlign: TextAlign.center,
          style: AppTypography.headlineSmall.copyWith(
            fontSize: responsive.sFont(18, minSize: 16),
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        SizedBox(height: responsive.s(16)),
        SizedBox(
          width: selectedPeriod == SubscriptionPeriod.monthly
              ? responsive.s(243)
              : responsive.s(323),
          child: Text(
            LocaleKeys.subscription.management.subtitle.tr(),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: responsive.sFont(16, minSize: 14),
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
