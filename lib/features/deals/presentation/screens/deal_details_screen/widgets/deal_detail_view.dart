import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/features/deals/domain/entities/deal_details_type.dart';
import 'package:waffir/features/deals/presentation/screens/deal_details_screen/widgets/deal_detail_cta.dart';
import 'package:waffir/features/deals/presentation/screens/deal_details_screen/widgets/deal_info_sections.dart';

/// Main scrollable view for Deal Details matching StoreDetailView pattern.
class DealDetailView extends HookWidget {
  const DealDetailView({
    super.key,
    required this.dealId,
    required this.dealType,
    required this.isRTL,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.onShopNow,
    required this.onShare,
    this.price,
    this.originalPrice,
    this.discountPercent,
    this.promoCode,
    this.terms,
    this.refUrl,
  });

  final String dealId;
  final DealDetailsType dealType;
  final bool isRTL;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String description;
  final VoidCallback onShopNow;
  final VoidCallback onShare;

  // Product specific
  final double? price;
  final double? originalPrice;
  final int? discountPercent;

  // Store/Bank specific
  final String? promoCode;
  final String? terms;
  final String? refUrl;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final isTermsExpanded = useState(false);

    final hasRefUrl = (refUrl ?? '').trim().isNotEmpty;

    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(child: DealHeroImage(imageUrl: imageUrl)),
              SliverToBoxAdapter(child: SizedBox(height: responsive.s(6))),
            ];
          },
          body: CustomScrollView(
            slivers: [
              // Title section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: responsive.s(12)),
                  child: DealTitleSection(title: title, subtitle: subtitle.isNotEmpty ? subtitle : null),
                ),
              ),
              // Section divider
              const SliverToBoxAdapter(child: StoreSectionDivider()),
              SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),

              // Price section (for product deals)
              if (price != null) ...[
                SliverToBoxAdapter(
                  child: DealPriceSection(
                    price: price!,
                    originalPrice: originalPrice,
                    discountPercent: discountPercent,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
              ],

              // Description section
              if (description.isNotEmpty) ...[
                SliverToBoxAdapter(child: DealDescriptionSection(description: description)),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
              ],

              // Promo code section
              if ((promoCode ?? '').trim().isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: DealPromoCodeCard(
                    promoCode: promoCode!,
                    dealId: dealId,
                    dealType: dealType.routeValue,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
              ],

              // Terms section
              if ((terms ?? '').trim().isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: DealTermsSection(
                    terms: terms!,
                    isExpanded: isTermsExpanded.value,
                    onToggle: () => isTermsExpanded.value = !isTermsExpanded.value,
                    dealId: dealId,
                    dealType: dealType.routeValue,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
                const SliverToBoxAdapter(child: StoreSectionDivider()),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
              ],

              // Reference URL section
              if (hasRefUrl) ...[
                SliverToBoxAdapter(
                  child: DealRefUrlSection(
                    refUrl: refUrl!,
                    dealId: dealId,
                    dealType: dealType.routeValue,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: responsive.s(12))),
              ],

              // Bottom padding for CTA overlay
              SliverToBoxAdapter(
                child: SizedBox(
                  height: responsive.s(96) + responsive.bottomSafeArea + responsive.s(32),
                ),
              ),
            ],
          ),
        ),

        // Header overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: DealPageHeaderOverlay(isRTL: isRTL, dealType: dealType),
        ),

        // Bottom CTA overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: DealPageBottomCta(
            onShopNow: onShopNow,
            onShare: onShare,
            hasRefUrl: hasRefUrl,
          ),
        ),
      ],
    );
  }
}
