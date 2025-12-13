import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';

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
          padding: responsive.scalePadding(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'See All Outlets',
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
                        'Take Me to Nearest Outlet',
                        style: AppTextStyles.storePageOutletRight.copyWith(color: colorScheme.onPrimary),
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
                      'assets/icons/arrow_icon.svg',
                      fit: BoxFit.contain,
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
  const StorePricesSection({super.key, required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${store.name} 20% Discount on Selected items.',
            style: AppTextStyles.storePageDealHeadline.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: responsive.scale(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StoreDiscountTag(
                label: '20% Off',
                backgroundColor: promoColors?.discountBg ?? colorScheme.primaryContainer,
                textColor: promoColors?.discountText ?? colorScheme.primary,
              ),
              SizedBox(width: responsive.scale(8)),
              Expanded(
                child: Text(
                  'At ${store.name} store',
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
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(Color(0xFF0F352D), BlendMode.srcIn),
              ),
            ),
            SizedBox(width: responsive.scale(4)),
            Text(
              label,
              style: AppTextStyles.storePageDiscountLabel.copyWith(color: textColor),
            ),
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
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16), vertical: responsive.scale(8)),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks! We’ll inspect this offer.')),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: responsive.scale(24),
              height: responsive.scale(24),
              child: SvgPicture.asset(
                'assets/icons/store_detail/error.svg',
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
              ),
            ),
            SizedBox(width: responsive.scale(4)),
            Text(
              'Report Expired',
              style: AppTextStyles.storePageReportExpired.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product info section (Figma node 54:5578).
class StoreProductInfoSection extends StatelessWidget {
  const StoreProductInfoSection({
    super.key,
    required this.detailsBody,
    required this.featuresBody,
  });

  final String detailsBody;
  final String featuresBody;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StoreDetailsBlock(
            title: 'Details:',
            body: detailsBody,
            titleStyle: AppTextStyles.storePageDetailsTitle.copyWith(color: colorScheme.onSurface),
            bodyStyle: AppTextStyles.storePageInfoBody.copyWith(color: colorScheme.onSurface),
          ),
          SizedBox(height: responsive.scale(16)),
          StoreDetailsBlock(
            title: 'Features:',
            body: featuresBody,
            titleStyle: AppTextStyles.storePageFeaturesTitle.copyWith(color: colorScheme.onSurface),
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
