import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/promo_colors_extension.dart';

/// Card actions widget - like and comment actions with counts
///
/// Displays like and comment icons with counts matching Figma design.
/// Icons: 16×16px, Text: 12px regular, #A3A3A3
///
/// Example usage:
/// ```dart
/// CardActions(
///   likeCount: 45,
///   commentCount: 45,
///   onLike: () => print('Liked'),
///   onComment: () => print('Commented'),
/// )
/// ```
class CardActions extends StatelessWidget {
  const CardActions({
    super.key,
    this.likeCount,
    this.commentCount,
    this.onLike,
    this.onComment,
    this.isLiked = false,
  });

  final int? likeCount;
  final int? commentCount;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final promo = Theme.of(context).extension<PromoColors>()!;
    final Color actionColor = promo.actionCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like action
        if (likeCount != null)
          _ActionItem(
            svgAsset: 'assets/icons/like_inactive.svg',
            iconColor: isLiked ? colorScheme.error : actionColor,
            count: likeCount!,
            onTap: onLike,
          ),

        if (likeCount != null && commentCount != null)
          const SizedBox(width: 24), // Gap between actions (from Figma)

        // Comment action
        if (commentCount != null)
          _ActionItem(
            svgAsset: 'assets/icons/comment.svg',
            iconColor: actionColor,
            count: commentCount!,
            onTap: onComment,
          ),
      ],
    );
  }
}

/// Individual action item (like or comment)
class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.svgAsset,
    required this.iconColor,
    required this.count,
    this.onTap,
  });

  final String svgAsset;
  final Color iconColor;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4), // Touch target padding
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon (16×16px from Figma)
            SvgPicture.asset(
              svgAsset,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 4), // Gap between icon and count
            // Count text
            SizedBox(
              width: 15.15, // Width from Figma
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400, // Regular
                  color: iconColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
