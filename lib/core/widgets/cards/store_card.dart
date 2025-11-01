import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/discount_tag_pill.dart';

/// A pixel-perfect card widget for displaying store information
///
/// Specifications from Figma (Node 54:2352):
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
/// - category: Optional, not in Figma variant 54:2352
/// - rating: Optional, not in Figma variant 54:2352
class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container (160×160px, padding 8px, white bg, 1px border)
          // Uses Stack to overlay favorite button
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              children: [
                // Main image container
                Container(
                  width: 160,
                  height: 160,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF), // White background from Figma
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05), // rgba(0,0,0,0.05)
                      width: 1,
                    ),
                    borderRadius: BorderRadius.zero, // No border radius per Figma
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // Contain (not cover) per Figma
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFFFFFFF),
                        child: const Icon(
                          Icons.store,
                          size: 32,
                          color: Color(0xFF9CA3AF),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFFFFFFFF),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF00D9A3),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Favorite button (top-left corner)
                if (onFavoriteToggle != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5), // Light gray background
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.star : Icons.star_outline,
                          size: 18,
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

          const SizedBox(height: 4), // 4px gap between image and info

          // Info Container (160px width, column with 8px gap, NO padding)
          SizedBox(
            width: 160,
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
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700, // Bold (700)
                        height: 1.4, // 1.4em line height from Figma
                        color: Color(0xFF151515), // Exact color from Figma
                      ),
                      maxLines: 2, // Allow wrapping (not single line)
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Discount Tag (8px gap from store name via parent column)
                if (discountText != null) ...[
                  const SizedBox(height: 8),
                  DiscountTagPill(
                    discountText: discountText!,
                    showIcon: true,
                  ),
                ],

                // Distance Text (8px gap from previous element)
                if (distance != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    distance!,
                    style: const TextStyle(
                      fontFamily: 'Parkinsans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.15, // 1.15em line height from Figma
                      color: Color(0xFF595959), // Exact color from Figma
                    ),
                  ),
                ],

                // Legacy: Category and Rating (backward compatibility)
                if (category != null && distance == null) ...[
                  const SizedBox(height: 8),
                  Text(
                    category!,
                    style: const TextStyle(
                      fontFamily: 'Parkinsans',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA3A3A3),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                if (rating != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFBBF24),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF151515),
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
