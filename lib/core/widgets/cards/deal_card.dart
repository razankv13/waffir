import 'package:flutter/material.dart';

/// A card widget for displaying deal alerts in notifications
///
/// Example usage:
/// ```dart
/// DealCard(
///   title: 'New Deal Alert',
///   description: 'Nike Air Max 2025 - 20% OFF',
///   timestamp: '2 hours ago',
///   imageUrl: 'https://example.com/product.jpg',
///   onTap: () => navigateToDeal(),
/// )
/// ```
class DealCard extends StatelessWidget {
  const DealCard({
    super.key,
    required this.title,
    required this.description,
    this.timestamp,
    this.imageUrl,
    this.onTap,
    this.isRead = false,
  });

  final String title;
  final String description;
  final String? timestamp;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deal Image (optional)
            if (imageUrl != null)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_fire_department,
                        size: 24,
                        color: colorScheme.onSurfaceVariant,
                      );
                    },
                  ),
                ),
              ),

            // Gap
            if (imageUrl != null) const SizedBox(width: 12),

            // Deal Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      timestamp!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Unread indicator
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
