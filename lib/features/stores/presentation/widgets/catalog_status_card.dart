import 'package:flutter/material.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

enum CatalogStatusCardVariant { empty, error }

class CatalogStatusCard extends StatelessWidget {
  const CatalogStatusCard({
    super.key,
    required this.variant,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final CatalogStatusCardVariant variant;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final icon = switch (variant) {
      CatalogStatusCardVariant.empty => Icons.local_offer_outlined,
      CatalogStatusCardVariant.error => Icons.error_outline,
    };

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.all(16)),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(responsive.scale(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: responsive.scale(22), color: colorScheme.onSurfaceVariant),
          SizedBox(width: responsive.scale(12)),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(width: responsive.scale(8)),
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

