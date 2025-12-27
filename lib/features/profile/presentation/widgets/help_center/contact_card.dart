import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// A contact card widget for the Help Center screen.
///
/// Displays a contact option with an icon and label in a vertical layout.
/// Matches Figma specs (node 8208:7227):
/// - White background (#FFFCFC)
/// - 1px border #F2F2F2
/// - 10px border radius
/// - 32px vertical, 16px horizontal padding
/// - Icon size: 27×27px
/// - Gap: 8px between icon and label
/// - Label: Parkinsans 500, 9px, #0F352D
class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// The icon widget to display (27×27px)
  final Widget icon;

  /// The label text to display below the icon
  final String label;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.rs;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: responsive.sBorderRadius(BorderRadius.circular(10)),
          child: Ink(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: responsive.sBorderRadius(
                BorderRadius.circular(10),
              ),
              border: Border.all(
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
            child: Container(
              padding: responsive.sPadding(
                const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon: 27×27px (from Figma)
                  SizedBox(
                    width: responsive.s(27),
                    height: responsive.s(27),
                    child: icon,
                  ),
                  // Gap: 8px (from Figma)
                  SizedBox(height: responsive.s(8)),
                  // Label: Parkinsans 500, 9px (from Figma)
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: responsive.sFont(9, minSize: 8),
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary, // #0F352D
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
