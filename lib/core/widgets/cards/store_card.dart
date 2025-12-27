import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/core/widgets/images/app_network_image.dart';
import 'package:waffir/core/widgets/products/discount_tag_pill.dart';

/// A pixel-perfect card widget for displaying store information
///
/// Specifications from Figma (Node 54:3054):
///
/// **Main Structure:**
/// - Column layout with 4px gap
/// - Hug sizing (no fixed outer width)
/// - No background color on main card
///
/// **Image Container:**
/// - Size: 160×160px (fixed)
/// - Padding: 8px
/// - Background: #FFFFFF (white)
/// - Border: 1px rgba(0,0,0,0.05)
/// - Border radius: 0px (no rounded corners)
/// - Image fit: contain (not cover!)
/// - Favorite button: 32×32px circular button in top-left (8px from edges)
///   - Background: #F5F5F5 (light gray)
///   - Icon: Star (filled when favorited, outlined when not)
///   - Color: #FBBF24 (gold) when favorited, #595959 (gray) when not
///
/// **Info Container:**
/// - Width: 160px, height: hug
/// - Column with 8px gap (NO padding)
///
/// **Store Name (wrapped in Frame 142):**
/// - Font: Parkinsans, 14px, weight 700 (bold)
/// - Line height: 1.4em
/// - Color: #151515
/// - Max lines: 2 (allows wrapping)
///
/// **Discount Tag:**
/// - Implemented via DiscountTagPill widget
/// - Background: #DCFCE7, padding: 2px 8px
/// - Border radius: 100px (pill shape)
///
/// **Distance:**
/// - Font: Parkinsans, 12px, weight 500
/// - Line height: 1.15em
/// - Color: #595959
///
/// Example usage:
/// ```dart
/// StoreCard(
///   storeId: 'store_001',
///   imageUrl: 'https://example.com/store.jpg',
///   storeName: 'Levis - Black Friday Online wide Store',
///   discountText: '20% off',
///   distance: '-,- kilometers',
///   isFavorite: false,
///   onTap: () => navigateToStore(),
///   onFavoriteToggle: () => toggleFavorite(),
/// )
/// ```
///
/// **Legacy fields (backward compatibility):**
/// - category: Optional, not in Figma variant 54:3054
/// - rating: Optional, not in Figma variant 54:3054
class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    this.storeId,
    required this.imageUrl,
    required this.storeName,
    this.category,
    this.distance,
    this.rating,
    this.discountText,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final String? storeId;
  final String imageUrl;
  final String storeName;

  /// [Deprecated] Not in Figma variant 54:2352 - kept for backward compatibility
  final String? category;

  final String? distance;

  /// [Deprecated] Not in Figma variant 54:2352 - kept for backward compatibility
  final double? rating;

  final String? discountText;
  final VoidCallback? onTap;

  /// Whether this store is marked as favorite
  final bool isFavorite;

  /// Callback when favorite button is tapped
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;
    final imageSize = responsive.s(160);
    final favoriteOffset = responsive.s(8);
    final favoriteSize = responsive.s(32);
    final favoriteIconSize = responsive.s(18);
    final gapSmall = responsive.s(4);
    final gapMedium = responsive.s(8);
    final borderWidth = responsive.sConstrained(1, min: 1, max: 1.5);
    final borderColor = Colors.black.withOpacity(0.05);

    return InkWell(
      onTap:
          onTap ??
          () {
            if (storeId == null) return;
            context.pushNamed(
              AppRouteNames.storeDetail,
              pathParameters: {AppRouteParams.id: storeId!},
            );
          },
      borderRadius: BorderRadius.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container (160×160px, padding 8px, white bg, 1px border)
          // Uses Stack to overlay favorite button
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Stack(
              children: [
                // Main image container
                ClipRect(
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    padding: responsive.sPadding(const EdgeInsets.all(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF), // White background from Figma
                      border: Border.all(
                        color: borderColor, // rgba(0,0,0,0.05)
                        width: borderWidth,
                      ),
                      borderRadius: BorderRadius.zero, // No border radius per Figma
                    ),
                    child: AppNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain, // Contain (not cover) per Figma
                      contentType: ImageContentType.store,
                      useResponsiveScaling: false, // Parent container handles scaling
                    ),
                  ),
                ),

                // Favorite button (top-left corner)
                if (onFavoriteToggle != null)
                  Positioned(
                    top: favoriteOffset,
                    left: favoriteOffset,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        width: favoriteSize,
                        height: favoriteSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5), // Light gray background
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: responsive.s(4),
                              offset: responsive.sOffset(const Offset(0, 2)),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_outline,
                          size: favoriteIconSize,
                          color: isFavorite
                              ? const Color(0xFFFBBF24) // Gold when favorited
                              : const Color(0xFF595959), // Gray when not favorited
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: gapSmall), // 4px gap between image and info
          // Info Container (160px width, column with 8px gap, NO padding)
          SizedBox(
            width: imageSize,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Frame 142: Store Name wrapper (column with 4px gap)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name Text
                    Text(
                      storeName,
                      style: TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: responsive.sFont(14),
                        fontWeight: FontWeight.w700, // Bold (700)
                        height: 1.4, // 1.4em line height from Figma
                        color: const Color(0xFF151515), // Exact color from Figma
                      ),
                      maxLines: 2, // Allow wrapping (not single line)
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Discount Tag (8px gap from store name via parent column)
                if (discountText != null) ...[
                  SizedBox(height: gapMedium),
                  DiscountTagPill(discountText: discountText!, showIcon: true),
                ],

                // Distance Text (8px gap from previous element)
                if (distance != null) ...[
                  SizedBox(height: gapMedium),
                  Text(
                    distance!,
                    style: TextStyle(
                      fontFamily: 'Parkinsans',
                      fontSize: responsive.sFont(12),
                      fontWeight: FontWeight.w500,
                      height: 1.15, // 1.15em line height from Figma
                      color: const Color(0xFF595959), // Exact color from Figma
                    ),
                  ),
                ],

                // Legacy: Category and Rating (backward compatibility)
                if (category != null && distance == null) ...[
                  SizedBox(height: gapMedium),
                  Text(
                    category!,
                    style: TextStyle(
                      fontFamily: 'Parkinsans',
                      fontSize: responsive.sFont(12),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA3A3A3),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                if (rating != null) ...[
                  SizedBox(height: gapMedium),
                  Row(
                    children: [
                      Icon(Icons.star, size: responsive.s(12), color: const Color(0xFFFBBF24)),
                      SizedBox(width: gapSmall),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: responsive.sFont(12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF151515),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
