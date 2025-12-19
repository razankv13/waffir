import 'package:flutter/material.dart';

import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Store purchase confirmation bottom sheet
///
/// Figma: `Bottom Sheet` (node 7935:10161)
class StorePurchaseBottomSheet extends StatelessWidget {
  const StorePurchaseBottomSheet({
    super.key,
    this.onClose,
    this.onPurchased,
    this.onBrowsing,
  });

  final VoidCallback? onClose;
  final VoidCallback? onPurchased;
  final VoidCallback? onBrowsing;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.scale(24))),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B1B1B).withValues(alpha: 0.12),
            offset: Offset(responsive.scale(2), responsive.scale(4)),
            blurRadius: responsive.scale(25),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: responsive.scale(48) + responsive.bottomSafeArea,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: responsive.scale(6),
                right: responsive.scale(6),
                top: responsive.scale(6),
              ),
              child: SizedBox(
                height: responsive.scale(44),
                child: Stack(
                  children: [
                    Positioned(
                      top: responsive.scale(16),
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: responsive.scale(32),
                          height: responsive.scale(6),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(responsive.scale(9999)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _CloseButton(onTap: onClose ?? () => Navigator.of(context).pop()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.scale(12)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.scale(24)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                    child: Column(
                      children: [
                        Text(
                          'Did you make a purchase?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.storePageDealHeadline.copyWith(color: colorScheme.onSurface),
                        ),
                        SizedBox(height: responsive.scale(12)),
                        Text(
                          'We’d love to know if you bought something from the store so we can track your savings.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: responsive.scaleFontSize(14, minSize: 12),
                            height: 1.4,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.scale(32)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SheetButton(
                        label: 'Yes, I purchased',
                        variant: _SheetButtonVariant.primary,
                        onTap: onPurchased ?? () => Navigator.of(context).pop(),
                      ),
                      SizedBox(height: responsive.scale(12)),
                      _SheetButton(
                        label: 'No, just browsing',
                        variant: _SheetButtonVariant.secondary,
                        onTap: onBrowsing ?? () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: responsive.scale(44),
      height: responsive.scale(44),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Container(
              width: responsive.scale(32),
              height: responsive.scale(32),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  size: responsive.scale(12),
                  color: const Color(0xFF757575),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _SheetButtonVariant { primary, secondary }

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.variant,
    required this.onTap,
  });

  final String label;
  final _SheetButtonVariant variant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    final isPrimary = variant == _SheetButtonVariant.primary;

    return SizedBox(
      height: responsive.scale(48),
      child: Material(
        color: isPrimary ? colorScheme.primary : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.scale(30)),
          side: isPrimary ? BorderSide.none : BorderSide(color: colorScheme.primary, width: responsive.scale(2)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(responsive.scale(30)),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.storePageCta.copyWith(
                color: isPrimary ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
