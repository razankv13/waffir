import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/waffir_back_button.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';

/// Pixel-perfect header overlay for Deal Page (matching StorePageHeaderOverlay).
class DealPageHeaderOverlay extends StatelessWidget {
  const DealPageHeaderOverlay({
    super.key,
    required this.isRTL,
    required this.dealType,
  });

  final bool isRTL;
  final DealDetailsType dealType;

  String _getPillLabel() {
    return switch (dealType) {
      DealDetailsType.product => LocaleKeys.dealDetails.labels.productDeal.tr(),
      DealDetailsType.store => LocaleKeys.dealDetails.labels.storeOffer.tr(),
      DealDetailsType.bank => LocaleKeys.dealDetails.labels.bankOffer.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    final shadow = BoxShadow(
      color: colorScheme.surfaceContainerHighest,
      blurRadius: responsive.scale(8),
      spreadRadius: responsive.scale(2),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.71, 1.0],
          colors: [colorScheme.surface, colorScheme.surface.withValues(alpha: 0.0)],
        ),
      ),
      padding: EdgeInsets.only(
        top: responsive.scale(64),
        left: responsive.scale(16),
        right: responsive.scale(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WaffirBackButton(size: responsive.scale(44), padding: EdgeInsets.zero),
          _DealTypePill(label: _getPillLabel(), shadow: shadow),
        ],
      ),
    );
  }
}

class _DealTypePill extends StatelessWidget {
  const _DealTypePill({required this.label, required this.shadow});

  final String label;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(responsive.scale(60)),
        boxShadow: [shadow],
      ),
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        child: Text(
          label,
          style: AppTextStyles.storePageHeaderLabel.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }
}

/// Pixel-perfect bottom CTA overlay for Deal Page (matching StorePageBottomCta).
class DealPageBottomCta extends StatelessWidget {
  const DealPageBottomCta({
    super.key,
    required this.onShopNow,
    required this.onShare,
    this.hasRefUrl = true,
  });

  final VoidCallback onShopNow;
  final VoidCallback onShare;
  final bool hasRefUrl;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: responsive.scale(96),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.49],
          colors: [colorScheme.surface.withValues(alpha: 0.0), colorScheme.surface],
        ),
      ),
      padding: EdgeInsets.only(
        left: responsive.scale(16),
        right: responsive.scale(16),
        bottom: responsive.scale(48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: responsive.scale(247),
            height: responsive.scale(48),
            child: Material(
              color: hasRefUrl ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(responsive.scale(30)),
              child: InkWell(
                borderRadius: BorderRadius.circular(responsive.scale(30)),
                onTap: hasRefUrl
                    ? () {
                        unawaited(HapticFeedback.mediumImpact());
                        onShopNow();
                      }
                    : null,
                child: Center(
                  child: Text(
                    LocaleKeys.dealDetails.actions.shopNow.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.storePageCta.copyWith(
                      color: hasRefUrl ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.scale(16)),
          SizedBox(
            width: responsive.scale(44),
            height: responsive.scale(44),
            child: Material(
              color: colorScheme.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  unawaited(HapticFeedback.mediumImpact());
                  onShare();
                },
                child: Center(
                  child: SizedBox(
                    width: responsive.scale(20),
                    height: responsive.scale(20),
                    child: SvgPicture.asset(
                      'assets/icons/store_detail/share_ios.svg',
                      colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
