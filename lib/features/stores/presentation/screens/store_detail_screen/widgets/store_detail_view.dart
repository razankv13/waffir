import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/product_page_comments_section.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_cta.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_engagement_sections.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_info_sections.dart';

class StoreDetailView extends StatelessWidget {
  const StoreDetailView({
    super.key,
    required this.store,
    required this.isRTL,
    required this.isFavorite,
    required this.testimonials,
    required this.onToggleFavorite,
    required this.offers,
    required this.onOfferTap,
    required this.isLoadingOffers,
  });

  final StoreModel store;
  final bool isRTL;
  final bool isFavorite;
  final List<StoreTestimonial> testimonials;
  final VoidCallback onToggleFavorite;
  final List<StoreOffer> offers;
  final ValueChanged<StoreOffer> onOfferTap;
  final bool isLoadingOffers;

  /// Gets the top offer with highest discount.
  /// Falls back to first offer if no discount data available.
  StoreOffer? _getTopOffer(List<StoreOffer> offers) {
    if (offers.isEmpty) return null;
    return offers.reduce((best, current) {
      final bestDiscount = best.discountMaxPercent ?? 0;
      final currentDiscount = current.discountMaxPercent ?? 0;
      return currentDiscount > bestDiscount ? current : best;
    });
  }

  /// Derives features body from offer promo codes.
  /// Returns null if no promo codes available.
  String? _buildFeaturesBody(List<StoreOffer> offers) {
    final promoCodes = offers
        .where((o) => o.promoCode != null && o.promoCode!.trim().isNotEmpty)
        .map((o) => o.promoCode!)
        .take(3)
        .toList();
    if (promoCodes.isEmpty) return null;
    return 'Use promo codes: ${promoCodes.join(", ")} when checking out.';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final productTheme =
        Theme.of(context).extension<ProductPageTheme>() ??
        ProductPageTheme.light;

    final storeComments = testimonials
        .map(
          (testimonial) => ProductPageComment(
            author: testimonial.author,
            subtitle: testimonial.location,
            body: testimonial.body,
            timeText: '3 hours ago',
            helpfulCount: 21,
            avatarAssetPath: 'assets/images/product_page/avatar.png',
          ),
        )
        .toList();

    final heroUrl = (store.bannerUrl != null && store.bannerUrl!.isNotEmpty)
        ? store.bannerUrl!
        : store.imageUrl;

    // Get top offer (highest discount)
    final topOffer = _getTopOffer(offers);

    // Derive features from offer promo codes (no hardcoded fallback)
    final featuresBody = _buildFeaturesBody(offers);

    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _StoreHeroImage(imageUrl: heroUrl)),
              SliverToBoxAdapter(child: SizedBox(height: responsive.s(6))),
            ];
          },
          body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: StoreOutletBanner()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.s(16),
                    vertical: responsive.s(12),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: StoreActionsSection(
                      isFavorite: isFavorite,
                      onToggleFavorite: onToggleFavorite,
                      offers: offers,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                SliverToBoxAdapter(
                  child: StorePricesSection(store: store, offers: offers),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                const SliverToBoxAdapter(child: StoreAdditionalActions()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                SliverToBoxAdapter(
                  child: StoreProductInfoSection(featuresBody: featuresBody),
                ),
                // Website section - only if website URL exists
                if (store.website != null && store.website!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: StoreWebsiteSection(websiteUrl: store.website!),
                  ),
                // Categories chips - only if categories exist
                if (store.categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: StoreCategoriesChips(categories: store.categories),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(16)),
                ),
                // Single top offer display
                if (isLoadingOffers)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.s(16),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (topOffer != null)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.s(16),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _StoreOfferTile(
                        offer: topOffer,
                        isRTL: isRTL,
                        onTap: () => onOfferTap(topOffer),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.s(6)),
                ),
                ProductPageCommentsSection(
                  theme: productTheme,
                  comments: storeComments,
                  defaultAvatarAssetPath:
                      'assets/images/product_page/avatar.png',
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        responsive.s(96) +
                        responsive.bottomSafeArea +
                        responsive.s(32),
                  ),
                ),
              ],
            ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: StorePageHeaderOverlay(isRTL: isRTL),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StorePageBottomCta(storeName: store.name),
        ),
        // Retain this invisible area so taps/scroll don’t fight the bottom overlay.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: SizedBox(
              height: responsive.s(0),
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}

class _StoreHeroImage extends StatelessWidget {
  const _StoreHeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    return SizedBox(
      height: responsive.s(390),
      child: Container(
        padding: responsive.sPadding(const EdgeInsets.all(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: responsive.s(1),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox.expand(
            child: AppNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.fill,
              contentType: ImageContentType.store,
              useResponsiveScaling: false,
              errorWidget: const ColoredBox(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class StoreSectionDivider extends StatelessWidget {
  const StoreSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 1,
      child: ColoredBox(color: colorScheme.surfaceContainerHighest),
    );
  }
}

class _StoreOfferTile extends StatelessWidget {
  const _StoreOfferTile({
    required this.offer,
    required this.isRTL,
    required this.onTap,
  });

  final StoreOffer offer;
  final bool isRTL;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final title = offer.localizedTitle(isArabic: isRTL);
    final subtitle = offer.localizedDescription(isArabic: isRTL);

    String? discountLabel() {
      final min = offer.discountMinPercent;
      final max = offer.discountMaxPercent;
      if (min == null && max == null) return null;
      if (min != null && max != null && min != max)
        return '${min.toString()}% - ${max.toString()}%';
      final value = (max ?? min);
      return value == null ? null : '${value.toString()}%';
    }

    final label = discountLabel();

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(responsive.s(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.s(12)),
        onTap: onTap,
        child: Padding(
          padding: responsive.sPadding(const EdgeInsets.all(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive.s(72),
                height: responsive.s(72),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(responsive.s(10)),
                ),
                child: offer.imageUrl == null || offer.imageUrl!.trim().isEmpty
                    ? Icon(
                        Icons.local_offer_outlined,
                        color: colorScheme.onSurfaceVariant,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          responsive.s(10),
                        ),
                        child: AppNetworkImage(
                          imageUrl: offer.imageUrl!,
                          fit: BoxFit.cover,
                          contentType: ImageContentType.deal,
                          useResponsiveScaling: false,
                          errorWidget: Icon(
                            Icons.local_offer_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: responsive.s(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: responsive.s(4)),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (label != null) ...[
                      SizedBox(height: responsive.s(8)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: responsive.sPadding(
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              responsive.s(999),
                            ),
                          ),
                          child: Text(
                            label,
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
