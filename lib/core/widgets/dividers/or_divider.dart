import 'package:flutter/material.dart';

/// OR Divider widget for separating authentication methods
///
/// Features:
/// - Horizontal lines with centered text
/// - RTL/LTR support
/// - Themed colors
/// - Configurable text and spacing
///
/// Example usage:
/// ```dart
/// OrDivider(
///   text: 'OR',
/// )
/// ```
class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    this.text = 'OR',
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.spacing = 16.0,
  });

  final String text;
  final double thickness;
  final double indent;
  final double endIndent;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        if (indent > 0) SizedBox(width: indent),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        if (endIndent > 0) SizedBox(width: endIndent),
      ],
    );
  }
}
