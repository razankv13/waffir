import 'package:flutter/material.dart';

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
    const Color actionColor = Color(0xFFA3A3A3); // Gray from Figma

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like action
        if (likeCount != null)
          _ActionItem(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            iconColor: isLiked ? colorScheme.error : actionColor,
            count: likeCount!,
            onTap: onLike,
          ),

        if (likeCount != null && commentCount != null)
          const SizedBox(width: 24), // Gap between actions (from Figma)

        // Comment action
        if (commentCount != null)
          _ActionItem(
            icon: Icons.chat_bubble_outline,
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
    required this.icon,
    required this.iconColor,
    required this.count,
    this.onTap,
  });

  final IconData icon;
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
            Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: 4), // Gap between icon and count
            // Count text
            SizedBox(
              width: 15.15, // Width from Figma
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontFamily: 'Parkinsans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400, // Regular
                  color: Color(0xFFA3A3A3), // Gray from Figma
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
