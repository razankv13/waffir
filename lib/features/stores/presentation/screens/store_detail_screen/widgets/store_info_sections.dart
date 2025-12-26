import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Outlet banner (Figma node 54:5744).
class StoreOutletBanner extends StatelessWidget {
  const StoreOutletBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: responsive.scale(48.25),
      child: DecoratedBox(
        decoration: BoxDecoration(color: colorScheme.primary),
        child: Padding(
          padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.stores.detail.banner.seeAllOutlets.tr(),
                style: AppTextStyles.storePageOutletLeft.copyWith(color: colorScheme.onPrimary),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: responsive.scale(171.95),
                    height: responsive.scale(16.98),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        LocaleKeys.stores.detail.banner.nearestOutlet.tr(),
                        style: AppTextStyles.storePageOutletRight.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.scale(4)),
                  SizedBox(
                    width: responsive.scale(12),
                    height: responsive.scale(12),
                    child: SvgPicture.asset(
                      Assets.icons.arrowIcon.path,
                      colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Prices + discount tag row (Figma node 54:5560).
class StorePricesSection extends StatelessWidget {
  const StorePricesSection({super.key, required this.store, required this.offers});

  final StoreModel store;
  final List<StoreOffer> offers;

  /// Calculates discount range from offers.
  /// Returns null if no discount data available.
  String? _getDiscountRange() {
    final discounts = offers
        .expand((o) => [o.discountMinPercent, o.discountMaxPercent])
        .whereType<num>()
        .toList();
    if (discounts.isEmpty) return null;
    final minDiscount = discounts.reduce((a, b) => math.min(a, b));
    final maxDiscount = discounts.reduce((a, b) => math.max(a, b));
    if (minDiscount == maxDiscount) {
      return '${minDiscount.toInt()}%';
    }
    return '${minDiscount.toInt()}% - ${maxDiscount.toInt()}%';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();
    final discountLabel = _getDiscountRange();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            LocaleKeys.stores.detail.discountTitle.tr(args: [store.name]),
            style: AppTextStyles.storePageDealHeadline.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: responsive.scale(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (discountLabel != null)
                StoreDiscountTag(
                  label: discountLabel,
                  backgroundColor: promoColors?.discountBg ?? colorScheme.primaryContainer,
                  textColor: promoColors?.discountText ?? colorScheme.primary,
                )
              else
                const SizedBox.shrink(),
              SizedBox(width: responsive.scale(8)),
              Expanded(
                child: Text(
                  LocaleKeys.stores.detail.atStore.tr(args: [store.name]),
                  style: AppTextStyles.storePageAtStore.copyWith(color: colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StoreDiscountTag extends StatelessWidget {
  const StoreDiscountTag({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(responsive.scale(26.726573944091797)),
      ),
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.all(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: responsive.scale(16),
              height: responsive.scale(16),
              child: SvgPicture.asset(
                'assets/icons/store_detail/tag.svg',
                colorFilter: const ColorFilter.mode(Color(0xFF0F352D), BlendMode.srcIn),
              ),
            ),
            SizedBox(width: responsive.scale(4)),
            Text(label, style: AppTextStyles.storePageDiscountLabel.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}

/// Additional actions (Figma node 54:5572).
class StoreAdditionalActions extends StatelessWidget {
  const StoreAdditionalActions({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.scale(16),
        vertical: responsive.scale(8),
      ),
      child: InkWell(
        onTap: () {
          unawaited(HapticFeedback.mediumImpact());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.stores.detail.actions.reportSuccess.tr())),
          );
        },
        child: Row(
          children: [
            SizedBox(
              width: responsive.scale(24),
              height: responsive.scale(24),
              child: SvgPicture.asset(
                Assets.icons.storeDetail.error.path,
                colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: responsive.scale(4)),
            Text(
              LocaleKeys.productPage.actions.reportExpired.tr(),
              style: AppTextStyles.storePageReportExpired.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product info section (Figma node 54:5578).
/// Handles nullable content - returns empty if both are null.
class StoreProductInfoSection extends StatelessWidget {
  const StoreProductInfoSection({super.key, this.detailsBody, this.featuresBody});

  final String? detailsBody;
  final String? featuresBody;

  @override
  Widget build(BuildContext context) {
    // Return empty if no content available
    if (detailsBody == null && featuresBody == null) {
      return const SizedBox.shrink();
    }

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (detailsBody != null) ...[
            StoreDetailsBlock(
              title: LocaleKeys.productPage.info.details.tr(),
              body: detailsBody!,
              titleStyle: AppTextStyles.storePageDetailsTitle.copyWith(
                color: colorScheme.onSurface,
              ),
              bodyStyle: AppTextStyles.storePageInfoBody.copyWith(color: colorScheme.onSurface),
            ),
            if (featuresBody != null) SizedBox(height: responsive.scale(16)),
          ],
          if (featuresBody != null)
            StoreDetailsBlock(
              title: LocaleKeys.productPage.info.features.tr(),
              body: featuresBody!,
              titleStyle: AppTextStyles.storePageFeaturesTitle.copyWith(
                color: colorScheme.onSurface,
              ),
              bodyStyle: AppTextStyles.storePageInfoBody.copyWith(color: colorScheme.onSurface),
            ),
        ],
      ),
    );
  }
}

class StoreDetailsBlock extends StatelessWidget {
  const StoreDetailsBlock({
    super.key,
    required this.title,
    required this.body,
    required this.titleStyle,
    required this.bodyStyle,
  });

  final String title;
  final String body;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        SizedBox(height: responsive.scale(8)),
        Text(body, style: bodyStyle),
      ],
    );
  }
}

/// Displays store website link with a clickable row.
/// Returns empty if website is null or empty.
class StoreWebsiteSection extends StatelessWidget {
  const StoreWebsiteSection({super.key, required this.websiteUrl});

  final String websiteUrl;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Clean display URL (remove protocol)
    final displayUrl = websiteUrl.replaceFirst(RegExp(r'^https?://'), '');

    return InkWell(
      onTap: () async {
        unawaited(HapticFeedback.lightImpact());
        final uri = Uri.tryParse(
          websiteUrl.startsWith('http') ? websiteUrl : 'https://$websiteUrl',
        );
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Padding(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        child: Row(
          children: [
            Icon(Icons.language, color: colorScheme.primary, size: responsive.scale(24)),
            SizedBox(width: responsive.scale(12)),
            Expanded(
              child: Text(
                displayUrl,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.open_in_new,
              color: colorScheme.onSurfaceVariant,
              size: responsive.scale(18),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays store categories as chips.
/// Returns empty if categories list is empty.
class StoreCategoriesChips extends StatelessWidget {
  const StoreCategoriesChips({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      child: Wrap(
        spacing: responsive.scale(8),
        runSpacing: responsive.scale(8),
        children: categories.map((category) {
          return Container(
            padding: responsive.scalePadding(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(responsive.scale(16)),
            ),
            child: Text(
              category,
              style: textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          );
        }).toList(),
      ),
    );
  }
}
