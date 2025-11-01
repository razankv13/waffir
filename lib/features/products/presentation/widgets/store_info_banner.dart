import 'package:flutter/material.dart';
import 'package:waffir/core/widgets/products/rating_display.dart';
import 'package:waffir/features/products/domain/entities/store.dart';

/// Store information banner widget
///
/// Displays store name, logo, and basic info
/// Matches Figma specifications: 48.25px height, dark green background
class StoreInfoBanner extends StatelessWidget {
  const StoreInfoBanner({
    super.key,
    required this.store,
    this.onTap,
    this.showFollowButton = false,
    this.onFollowToggle,
  });

  final Store store;
  final VoidCallback? onTap;
  final bool showFollowButton;
  final VoidCallback? onFollowToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48.25,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFF0F352D), // Dark green from Figma
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Store info
            Expanded(
              child: Row(
                children: [
                  // Store logo
                  if (store.logoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        store.logoUrl!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildLogoPlaceholder(),
                      ),
                    )
                  else
                    _buildLogoPlaceholder(),

                  const SizedBox(width: 12),

                  // Store name and rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          store.name,
                          style: textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (store.rating != null) ...[
                          const SizedBox(height: 2),
                          RatingDisplay(
                            rating: store.rating!,
                            size: RatingSize.small,
                            showRatingText: false,
                            starColor: const Color(0xFFFBBF24), // Gold
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Follow button or arrow
            if (showFollowButton && onFollowToggle != null)
              _buildFollowButton(context, store.isFollowing)
            else
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.store_outlined,
        size: 18,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, bool isFollowing) {
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onFollowToggle,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
