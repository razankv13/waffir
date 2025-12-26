import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/services/clarity_service.dart';
import 'package:waffir/core/themes/app_text_styles.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';

// Re-export StoreSectionDivider for use in deal details
export 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_view.dart'
    show StoreSectionDivider;

/// Large hero image matching StoreHeroImage style (390px height).
class DealHeroImage extends StatelessWidget {
  const DealHeroImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: responsive.scale(390),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.all(16)),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: responsive.scale(1),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: imageUrl.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(responsive.scale(16)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.local_offer_outlined,
                    size: responsive.scale(64),
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              : SizedBox.expand(
                  child: AppNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    contentType: ImageContentType.deal,
                    useResponsiveScaling: false,
                    errorWidget: Container(
                      color: colorScheme.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: responsive.scale(64),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Deal title and subtitle section.
class DealTitleSection extends StatelessWidget {
  const DealTitleSection({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.storePageDealHeadline.copyWith(color: colorScheme.onSurface),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            SizedBox(height: responsive.scale(6)),
            Text(
              subtitle!,
              style: AppTextStyles.storePageInfoBody.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

/// Product price section with discount display (matching StorePricesSection style).
class DealPriceSection extends StatelessWidget {
  const DealPriceSection({
    super.key,
    required this.price,
    this.originalPrice,
    this.discountPercent,
  });

  final double price;
  final double? originalPrice;
  final int? discountPercent;

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final promoColors = Theme.of(context).extension<PromoColors>();
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.all(12)),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(responsive.scale(12)),
        ),
        child: Row(
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: textTheme.headlineSmall?.copyWith(
                color: hasDiscount ? colorScheme.error : colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hasDiscount) ...[
              SizedBox(width: responsive.scale(12)),
              Text(
                '\$${originalPrice!.toStringAsFixed(2)}',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: responsive.scale(10)),
              if (discountPercent != null)
                Container(
                  padding: responsive.scalePadding(
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  decoration: BoxDecoration(
                    color: promoColors?.discountBg ?? colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(responsive.scale(999)),
                  ),
                  child: Text(
                    '-$discountPercent%',
                    style: textTheme.labelMedium?.copyWith(
                      color: promoColors?.discountText ?? colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
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

/// Promo code card with copy button (matching current deal screen style).
class DealPromoCodeCard extends StatelessWidget {
  const DealPromoCodeCard({
    super.key,
    required this.promoCode,
    required this.dealId,
    required this.dealType,
  });

  final String promoCode;
  final String dealId;
  final String dealType;

  @override
  Widget build(BuildContext context) {
    if (promoCode.trim().isEmpty) return const SizedBox.shrink();

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.all(12)),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(responsive.scale(12)),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.dealDetails.labels.promoCode.tr(),
                    style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                  SizedBox(height: responsive.scale(6)),
                  Text(
                    promoCode,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: responsive.scale(1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: responsive.scale(12)),
            FilledButton.tonalIcon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: promoCode));
                if (!context.mounted) return;
                ScaffoldMessenger.maybeOf(context)
                  ?..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.dealDetails.success.promoCodeCopied.tr()),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                ClarityService.instance.logEvent(
                  'deal_cta_tapped',
                  properties: {
                    'dealId': dealId,
                    'dealType': dealType,
                    'action': 'copy_promo_code',
                  },
                );
              },
              icon: const Icon(Icons.copy_rounded),
              label: Text(LocaleKeys.buttons.copy.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Expandable terms section.
class DealTermsSection extends StatelessWidget {
  const DealTermsSection({
    super.key,
    required this.terms,
    required this.isExpanded,
    required this.onToggle,
    required this.dealId,
    required this.dealType,
  });

  final String terms;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String dealId;
  final String dealType;

  @override
  Widget build(BuildContext context) {
    if (terms.trim().isEmpty) return const SizedBox.shrink();

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final maxLines = isExpanded ? null : 4;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.all(12)),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(responsive.scale(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.dealDetails.labels.terms.tr(),
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.scale(8)),
            Text(
              terms,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              maxLines: maxLines,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            SizedBox(height: responsive.scale(8)),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  onToggle();
                  ClarityService.instance.logEvent(
                    'deal_terms_toggled',
                    properties: {
                      'dealId': dealId,
                      'dealType': dealType,
                      'expanded': !isExpanded,
                    },
                  );
                },
                child: Text(
                  isExpanded ? LocaleKeys.buttons.readLess.tr() : LocaleKeys.buttons.readMore.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Description section.
class DealDescriptionSection extends StatelessWidget {
  const DealDescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    if (description.trim().isEmpty) return const SizedBox.shrink();

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Text(
        description,
        style: AppTextStyles.storePageInfoBody.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

/// Website/reference URL section (matching StoreWebsiteSection style).
class DealRefUrlSection extends StatelessWidget {
  const DealRefUrlSection({
    super.key,
    required this.refUrl,
    required this.dealId,
    required this.dealType,
  });

  final String refUrl;
  final String dealId;
  final String dealType;

  @override
  Widget build(BuildContext context) {
    if (refUrl.trim().isEmpty) return const SizedBox.shrink();

    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Clean display URL (remove protocol)
    final displayUrl = refUrl.replaceFirst(RegExp(r'^https?://'), '');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(responsive.scale(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(responsive.scale(12)),
          onTap: () async {
            unawaited(HapticFeedback.lightImpact());
            final uri = Uri.tryParse(refUrl.startsWith('http') ? refUrl : 'https://$refUrl');
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              ClarityService.instance.logEvent(
                'deal_cta_tapped',
                properties: {'dealId': dealId, 'dealType': dealType, 'action': 'open_url'},
              );
            } else if (context.mounted) {
              ScaffoldMessenger.maybeOf(context)
                ?..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text(LocaleKeys.dealDetails.errors.couldNotOpenLink.tr()),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
          child: Padding(
            padding: responsive.scalePadding(const EdgeInsets.all(12)),
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
        ),
      ),
    );
  }
}
