import 'package:flutter/material.dart';
import 'package:waffir/core/themes/figma_product_page/product_page_theme.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/product_page_comments_section.dart';
import 'package:waffir/features/stores/data/models/store_model.dart';
import 'package:waffir/features/stores/domain/entities/catalog_category.dart';
import 'package:waffir/features/stores/domain/entities/store_offer.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/store_detail_controller.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_detail_cta.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_engagement_sections.dart';
import 'package:waffir/features/stores/presentation/screens/store_detail_screen/widgets/store_info_sections.dart';
import 'package:waffir/features/stores/presentation/widgets/catalog_search_filter_bar.dart';
import 'package:waffir/features/stores/presentation/widgets/catalog_status_card.dart';

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
    required this.hasMoreOffers,
    required this.isLoadingMoreOffers,
    required this.onLoadMoreOffers,
    required this.offersSearchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectedCategoryChanged,
  });

  final StoreModel store;
  final bool isRTL;
  final bool isFavorite;
  final List<StoreTestimonial> testimonials;
  final VoidCallback onToggleFavorite;
  final List<StoreOffer> offers;
  final ValueChanged<StoreOffer> onOfferTap;
  final bool isLoadingOffers;
  final bool hasMoreOffers;
  final bool isLoadingMoreOffers;
  final VoidCallback onLoadMoreOffers;
  final TextEditingController offersSearchController;
  final ValueChanged<String> onSearchChanged;
  final List<CatalogCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelectedCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
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

    final detailsBody =
        store.description ??
        'Levis has a 20% discount on selected items and 10% discount on discontinued items.';

    final sanitizedId = store.id
        .replaceAll(RegExp('[^A-Za-z0-9]'), '')
        .toUpperCase();
    final promoCode =
        (sanitizedId.isEmpty ? 'LEVI2' : sanitizedId.padRight(5, '0'))
            .substring(0, 5);

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
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (!hasMoreOffers || isLoadingMoreOffers) return false;
              if (notification.metrics.extentAfter > responsive.scale(500))
                return false;
              onLoadMoreOffers();
              return false;
            },
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: StoreOutletBanner()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
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
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                SliverToBoxAdapter(child: StorePricesSection(store: store)),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                const SliverToBoxAdapter(child: StoreAdditionalActions()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                SliverToBoxAdapter(
                  child: StoreProductInfoSection(
                    detailsBody: detailsBody,
                    featuresBody: featuresBody,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(16)),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.scale(16),
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _OffersHeader(storeName: store.name),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(12)),
                ),
                SliverToBoxAdapter(
                  child: CatalogSearchFilterBar(
                    controller: offersSearchController,
                    onSearchChanged: onSearchChanged,
                    searchPadding: const EdgeInsets.symmetric(horizontal: 16),
                    filters: [
                      if (categories.isNotEmpty)
                        _CategoryChips(
                          categories: categories,
                          selectedCategoryId: selectedCategoryId,
                          isArabic: isRTL,
                          onSelectedCategoryChanged: onSelectedCategoryChanged,
                        ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(12)),
                ),
                if (isLoadingOffers)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.scale(16),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (offers.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.scale(16),
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: _EmptyOffersState(),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.scale(16),
                    ),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => _StoreOfferTile(
                        offer: offers[index],
                        isRTL: isRTL,
                        onTap: () => onOfferTap(offers[index]),
                      ),
                      separatorBuilder: (context, _) =>
                          SizedBox(height: responsive.scale(12)),
                      itemCount: offers.length,
                    ),
                  ),
                if (isLoadingMoreOffers)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: responsive.scale(16),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
                ),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(
                  child: SizedBox(height: responsive.scale(6)),
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
                        responsive.scale(96) +
                        responsive.bottomSafeArea +
                        responsive.scale(32),
                  ),
                ),
              ],
            ),
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
              height: responsive.scale(0),
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

    return SizedBox(
      height: 1,
      child: ColoredBox(color: colorScheme.surfaceContainerHighest),
    );
  }
}

class _OffersHeader extends StatelessWidget {
  const _OffersHeader({required this.storeName});

  final String storeName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Offers',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          storeName,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedCategoryId,
    required this.isArabic,
    required this.onSelectedCategoryChanged,
  });

  final List<CatalogCategory> categories;
  final String? selectedCategoryId;
  final bool isArabic;
  final ValueChanged<String?> onSelectedCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: responsive.scale(40),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: responsive.scale(16)),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];
          final isSelected = isAll
              ? selectedCategoryId == null
              : category!.id == selectedCategoryId;
          final label = isAll
              ? 'All'
              : category!.localizedName(isArabic: isArabic);

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onSelectedCategoryChanged(category?.id),
            selectedColor: colorScheme.primaryContainer,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            backgroundColor: colorScheme.surfaceContainerHighest,
            side: BorderSide(color: colorScheme.outlineVariant),
          );
        },
        separatorBuilder: (context, _) => SizedBox(width: responsive.scale(8)),
        itemCount: categories.length + 1,
      ),
    );
  }
}

class _EmptyOffersState extends StatelessWidget {
  const _EmptyOffersState();

  @override
  Widget build(BuildContext context) {
    return const CatalogStatusCard(
      variant: CatalogStatusCardVariant.empty,
      message: 'No offers available right now.',
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
    final responsive = context.responsive;
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
      borderRadius: BorderRadius.circular(responsive.scale(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.scale(12)),
        onTap: onTap,
        child: Padding(
          padding: responsive.scalePadding(const EdgeInsets.all(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: responsive.scale(72),
                height: responsive.scale(72),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(responsive.scale(10)),
                ),
                child: offer.imageUrl == null || offer.imageUrl!.trim().isEmpty
                    ? Icon(
                        Icons.local_offer_outlined,
                        color: colorScheme.onSurfaceVariant,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          responsive.scale(10),
                        ),
                        child: Image.network(
                          offer.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.local_offer_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
              ),
              SizedBox(width: responsive.scale(12)),
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
                      SizedBox(height: responsive.scale(4)),
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
                      SizedBox(height: responsive.scale(8)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: responsive.scalePadding(
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              responsive.scale(999),
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
