import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

/// Product actions bar widget
///
/// Displays action buttons: favorite, share, cart
/// Matches Figma specifications with 12px vertical padding and 16px horizontal
class ProductActionsBar extends StatelessWidget {
  const ProductActionsBar({
    super.key,
    required this.isFavorite,
    this.onFavoriteToggle,
    this.onShare,
    this.onAddToCart,
    this.shareText,
  });

  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;
  final VoidCallback? onAddToCart;
  final String? shareText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Favorite button
          _ActionButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? const Color(0xFFEF4444) : colorScheme.onSurface,
            onTap: () {
              HapticFeedback.lightImpact();
              onFavoriteToggle?.call();
            },
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),

          // Action buttons group (share and cart)
          Row(
            children: [
              // Share button
              _ActionButton(
                icon: Icons.share_outlined,
                color: colorScheme.onSurface,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (onShare != null) {
                    onShare!();
                  } else if (shareText != null) {
                    Share.share(shareText!);
                  }
                },
                tooltip: 'Share product',
              ),

              const SizedBox(width: 8),

              // Cart button
              _ActionButton(
                icon: Icons.shopping_cart_outlined,
                color: colorScheme.onSurface,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onAddToCart?.call();
                },
                tooltip: 'Add to cart',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Action button widget
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 24,
          color: color,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
