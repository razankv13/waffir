import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:share_plus/share_plus.dart';

/// Product actions bar widget
///
/// Displays action buttons: favorite, share, cart
/// Matches Figma specifications with 12px vertical padding and 16px horizontal
class ProductActionsBar extends StatelessWidget {
  const ProductActionsBar({
    super.key,
    required this.isFavorite,
    this.favoriteCount,
    this.commentCount,
    this.onFavoriteToggle,
    this.onCommentTap,
    this.onShare,
    this.onAddToCart,
    this.shareText,
    this.showComment = false,
    this.showShare = true,
    this.showCart = true,
  });

  final bool isFavorite;
  final int? favoriteCount;
  final int? commentCount;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onCommentTap;
  final VoidCallback? onShare;
  final VoidCallback? onAddToCart;
  final String? shareText;
  final bool showComment;
  final bool showShare;
  final bool showCart;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Favorite action (pill with optional count, else circular)
          if (favoriteCount != null)
            _ActionPill(
              onTap: () {
                HapticFeedback.lightImpact();
                onFavoriteToggle?.call();
              },
              tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
              backgroundColor: const Color(0xFFF2F2F2),
              gap: responsive.scale(6),
              height: responsive.scale(44),
              padding: EdgeInsets.symmetric(horizontal: responsive.scale(6)),
              icon: isFavorite
                  ? SvgPicture.asset(
                      'assets/icons/like_active.svg',
                      width: responsive.scale(20),
                      height: responsive.scale(20),
                    )
                  : SvgPicture.asset(
                      'assets/icons/like_inactive.svg',
                      width: responsive.scale(20),
                      height: responsive.scale(20),
                      colorFilter: const ColorFilter.mode(Color(0xFF595959), BlendMode.srcIn),
                    ),
              label: '$favoriteCount',
              labelStyle: TextStyle(
                fontFamily: 'Parkinsans',
                fontWeight: FontWeight.w500,
                fontSize: responsive.scale(14),
                color: const Color(0xFF595959),
              ),
            )
          else
            _ActionButton(
              child: isFavorite
                  ? SvgPicture.asset(
                      'assets/icons/like_active.svg',
                      width: responsive.scale(20),
                      height: responsive.scale(20),
                    )
                  : SvgPicture.asset(
                      'assets/icons/like_inactive.svg',
                      width: responsive.scale(20),
                      height: responsive.scale(20),
                      colorFilter: const ColorFilter.mode(Color(0xFF595959), BlendMode.srcIn),
                    ),
              backgroundColor: const Color(0xFFF2F2F2),
              onTap: () {
                HapticFeedback.lightImpact();
                onFavoriteToggle?.call();
              },
              tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),

          // Action buttons group (share and cart)
          Row(
            children: [
              if (showComment) ...[
                // Comment action (pill with optional count)
                _ActionPill(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onCommentTap?.call();
                  },
                  tooltip: 'View comments',
                  backgroundColor: const Color(0xFFF2F2F2),
                  gap: responsive.scale(6),
                  height: responsive.scale(44),
                  padding: EdgeInsets.symmetric(horizontal: responsive.scale(12)),
                  icon: SvgPicture.asset(
                    'assets/icons/comment.svg',
                    width: responsive.scale(20),
                    height: responsive.scale(20),
                    colorFilter: const ColorFilter.mode(Color(0xFF595959), BlendMode.srcIn),
                  ),
                  label: commentCount != null ? '$commentCount' : null,
                  labelStyle: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontWeight: FontWeight.w500,
                    fontSize: responsive.scale(14),
                    color: const Color(0xFF595959),
                  ),
                ),
                SizedBox(width: responsive.scale(16)),
              ],
              // Share button
              if (showShare)
                _ActionButton(
                  child: Icon(
                    Icons.share_outlined,
                    size: responsive.scale(20),
                    color: const Color(0xFF595959),
                  ),
                  backgroundColor: const Color(0xFFF2F2F2),
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

              if (showShare && showCart) SizedBox(width: responsive.scale(16)),

              // Cart button
              if (showCart)
                _ActionButton(
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    size: responsive.scale(20),
                    color: const Color(0xFF595959),
                  ),
                  backgroundColor: const Color(0xFFF2F2F2),
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
    required this.child,
    required this.onTap,
    this.tooltip,
    this.backgroundColor = const Color(0xFFF2F2F2),
  });

  final Widget child;
  final VoidCallback onTap;
  final String? tooltip;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.scale(20)),
      child: Container(
        width: responsive.scale(40),
        height: responsive.scale(40),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}

/// Action pill widget (Figma: height 44, radius 1000, gap 6)
class _ActionPill extends StatelessWidget {
  const _ActionPill({
    required this.icon,
    required this.onTap,
    this.label,
    this.labelStyle,
    this.tooltip,
    this.backgroundColor = const Color(0xFFF2F2F2),
    this.gap = 6,
    this.height = 44,
    this.padding = const EdgeInsets.symmetric(horizontal: 6),
  });

  final Widget icon;
  final VoidCallback onTap;
  final String? label;
  final TextStyle? labelStyle;
  final String? tooltip;
  final Color backgroundColor;
  final double gap;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    Widget content = Container(
      height: responsive.scale(height),
      padding: EdgeInsets.symmetric(horizontal: responsive.scale(padding.horizontal / 2)).copyWith(
        left: responsive.scale(padding.left),
        right: responsive.scale(padding.right),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(responsive.scale(1000)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          if (label != null) ...[
            SizedBox(width: responsive.scale(gap)),
            Text(
              label!,
              style: labelStyle,
            ),
          ],
        ],
      ),
    );

    content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.scale(1000)),
      child: content,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: content);
    }
    return content;
  }
}
