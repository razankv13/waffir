import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/products/presentation/widgets/product_image_carousel.dart';
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
    required this.isFollowing,
    required this.testimonials,
    required this.onToggleFavorite,
    required this.onToggleFollow,
  });

  final StoreModel store;
  final bool isRTL;
  final bool isFavorite;
  final bool isFollowing;
  final List<StoreTestimonial> testimonials;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final heroImages = <String>[
      if (store.bannerUrl != null && store.bannerUrl!.isNotEmpty) store.bannerUrl!,
      if (store.imageUrl.isNotEmpty) store.imageUrl,
    ];

    final description =
        store.description ??
        'Discover curated apparel, footwear, and accessories with limited-time savings and bilingual support.';
    final sanitizedId = store.id.replaceAll(RegExp('[^A-Za-z0-9]'), '').toUpperCase();
    final promoCode = (sanitizedId.isEmpty ? 'WAFFI' : sanitizedId.padRight(5, '0')).substring(
      0,
      5,
    );
    final featuresBody =
        'Use promo code: $promoCode when checking out. Offers are valid for Saudi Arabia residents. Discount runs while supplies last.';

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ProductImageCarousel(
                imageUrls: heroImages.isEmpty ? [store.imageUrl] : heroImages,
                height: responsive.scale(390),
                showIndicators: heroImages.length > 1,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.scale(16),
                      vertical: responsive.scale(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const StoreOutletBanner(),
                        SizedBox(height: responsive.scale(8)),
                        StoreActionsSection(
                          isFavorite: isFavorite,
                          onToggleFavorite: onToggleFavorite,
                        ),
                        SizedBox(height: responsive.scale(16)),
                        StorePromoHighlight(store: store),
                        SizedBox(height: responsive.scale(16)),
                        const StoreAdditionalActions(),
                        SizedBox(height: responsive.scale(16)),
                        const StoreSectionDivider(),
                        SizedBox(height: responsive.scale(16)),
                        StoreDetailsBlock(
                          title: 'Details:',
                          body: description,
                          titleStyle: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: responsive.scaleFontSize(16),
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF151515),
                            height: 1.34,
                          ),
                          bodyStyle: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: responsive.scaleFontSize(14),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF151515),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: responsive.scale(16)),
                        const StoreSectionDivider(),
                        SizedBox(height: responsive.scale(16)),
                        StoreDetailsBlock(
                          title: 'Features:',
                          body: featuresBody,
                          titleStyle: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: responsive.scaleFontSize(16),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF151515),
                            height: 1.11,
                          ),
                          bodyStyle: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: responsive.scaleFontSize(14),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF151515),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                    child: const StoreSectionDivider(),
                  ),
                  SizedBox(height: responsive.scale(16)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
                    child: StoreTestimonialsSection(testimonials: testimonials),
                  ),
                  SizedBox(height: responsive.scale(120)),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: responsive.scale(64),
          left: isRTL ? null : responsive.scale(16),
          right: isRTL ? responsive.scale(16) : null,
          child: const StoreDetailBackButton(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: StoreDetailBottomBar(
            store: store,
            isFollowing: isFollowing,
            onToggleFollow: onToggleFollow,
          ),
        ),
      ],
    );
  }
}

class StoreSectionDivider extends StatelessWidget {
  const StoreSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.scale(0)),
      height: 1,
      decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
    );
  }
}
