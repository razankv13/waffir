import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

class SubscriptionProceedButton extends StatelessWidget {
  const SubscriptionProceedButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: theme.colorScheme.surface,
        padding: responsive.scalePadding(const EdgeInsets.all(16)),
        child: Center(
          child: Container(
            width: responsive.scale(330),
            height: responsive.scale(48),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F352D).withOpacity(0.15),
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: AppButton.primary(
              onPressed: onPressed,
              child: Text(
                LocaleKeys.subscription.management.proceed.tr(),
                style: AppTypography.labelLarge.copyWith(
                  fontSize: responsive.scaleFontSize(14, minSize: 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
