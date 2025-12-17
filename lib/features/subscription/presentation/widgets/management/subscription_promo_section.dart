import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

class SubscriptionPromoSection extends StatelessWidget {
  const SubscriptionPromoSection({
    super.key,
    required this.promoController,
    required this.onPromoChanged,
    required this.onApplyPromo,
  });

  final TextEditingController promoController;
  final ValueChanged<String> onPromoChanged;
  final VoidCallback onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: responsive.scale(243),
          child: Text(
            LocaleKeys.subscription.management.promo.question.tr(),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: responsive.scaleFontSize(16, minSize: 14),
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(height: responsive.scale(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: responsive.scale(232),
              height: responsive.scale(56),
              padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(16)),
              ),
              child: Center(
                child: TextField(
                  controller: promoController,
                  onChanged: onPromoChanged,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: responsive.scaleFontSize(16, minSize: 14),
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: LocaleKeys.subscription.management.promo.placeholder.tr(),
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      fontSize: responsive.scaleFontSize(16, minSize: 14),
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.scale(11)),
            GestureDetector(
              onTap: onApplyPromo,
              child: Container(
                width: responsive.scale(44),
                height: responsive.scale(44),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  size: responsive.scale(20),
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.2, duration: 400.ms);
  }
}
