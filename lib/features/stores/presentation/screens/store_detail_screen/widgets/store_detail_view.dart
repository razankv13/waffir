import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
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
  });

  final StoreModel store;
  final bool isRTL;
  final bool isFavorite;
  final List<StoreTestimonial> testimonials;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    final heroUrl = (store.bannerUrl != null && store.bannerUrl!.isNotEmpty)
        ? store.bannerUrl!
        : store.imageUrl;

    final detailsBody =
        store.description ??
        'Levis has a 20% discount on selected items and 10% discount on discontinued items.';

    final sanitizedId = store.id.replaceAll(RegExp('[^A-Za-z0-9]'), '').toUpperCase();
    final promoCode = (sanitizedId.isEmpty ? 'LEVI2' : sanitizedId.padRight(5, '0')).substring(
      0,
      5,
    );

    final featuresBody =
        'Use Promo code: $promoCode when checking out, offers are online valid for Saudi Arabia residents. '
        'Discount will expire on the 23rd of Oct, 2026 or while products last.';

    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: _StoreHeroImage(imageUrl: heroUrl)),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
            ];
          },
          body: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: StoreOutletBanner()),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.scale(16),
                  vertical: responsive.scale(12),
                ),
                sliver: SliverToBoxAdapter(
                  child: StoreActionsSection(
                    isFavorite: isFavorite,
                    onToggleFavorite: onToggleFavorite,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              SliverToBoxAdapter(child: StorePricesSection(store: store)),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              const SliverToBoxAdapter(child: StoreAdditionalActions()),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              const SliverToBoxAdapter(child: StoreSectionDivider()),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              SliverToBoxAdapter(
                child: StoreProductInfoSection(detailsBody: detailsBody, featuresBody: featuresBody),
              ),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              const SliverToBoxAdapter(child: StoreSectionDivider()),
              SliverToBoxAdapter(child: SizedBox(height: responsive.scale(6))),
              StoreCommentsSection(testimonials: testimonials),
              SliverToBoxAdapter(
                child: SizedBox(height: responsive.scale(96) + responsive.bottomSafeArea + responsive.scale(32)),
              ),
            ],
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: StorePageHeaderOverlay(isRTL: isRTL)),
        Positioned(bottom: 0, left: 0, right: 0, child: StorePageBottomCta(storeName: store.name)),
        // Retain this invisible area so taps/scroll don’t fight the bottom overlay.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: SizedBox(height: responsive.scale(0), width: double.infinity),
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
    final responsive = context.responsive;

    return SizedBox(
      height: responsive.scale(390),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.all(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: responsive.scale(1),
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox.expand(
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(color: Colors.white);
              },
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

    return SizedBox(height: 1, child: ColoredBox(color: colorScheme.surfaceContainerHighest));
  }
}
