import 'package:flutter/material.dart';

/// A card widget for displaying popular alerts
///
/// Example usage:
/// ```dart
/// AlertCard(
///   title: 'Electronics Sale',
///   description: 'Get notified when electronics go on sale',
///   icon: Icons.phone_android,
///   isSubscribed: false,
///   onToggle: (value) => print('Subscribed: $value'),
/// )
/// ```
class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.isSubscribed = false,
    this.onToggle,
  });

  final String title;
  final String description;
  final IconData? icon;
  final bool isSubscribed;
  final ValueChanged<bool>? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          if (icon != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: colorScheme.primary,
              ),
            ),

          // Gap
          if (icon != null) const SizedBox(width: 12),

          // Alert Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Subscribe/Unsubscribe Button
          TextButton(
            onPressed: () => onToggle?.call(!isSubscribed),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor: isSubscribed
                  ? colorScheme.primary
                  : colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              isSubscribed ? 'Subscribed' : 'Subscribe',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSubscribed
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
