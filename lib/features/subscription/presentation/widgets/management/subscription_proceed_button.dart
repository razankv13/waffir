import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/buttons/app_button.dart';

class SubscriptionProceedButton extends StatelessWidget {
  const SubscriptionProceedButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.onRestorePressed,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final VoidCallback? onRestorePressed;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);
    final theme = Theme.of(context);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: theme.colorScheme.surface,
        padding: responsive.sPadding(const EdgeInsets.all(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: responsive.s(330),
                height: responsive.s(48),
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
                  onPressed: isLoading ? null : onPressed,
                  child: isLoading
                      ? SizedBox(
                          width: responsive.s(20),
                          height: responsive.s(20),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          LocaleKeys.subscription.management.proceed.tr(),
                          style: AppTypography.labelLarge.copyWith(
                            fontSize: responsive.sFont(14, minSize: 12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
            if (onRestorePressed != null) ...[
              SizedBox(height: responsive.s(12)),
              TextButton(
                onPressed: isLoading ? null : onRestorePressed,
                child: Text(
                  LocaleKeys.subscription.restore.button.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: responsive.sFont(12, minSize: 10),
                    color: isLoading
                        ? theme.colorScheme.onSurface.withOpacity(0.38)
                        : theme.colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
