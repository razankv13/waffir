import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// A subscription option card with radio button selection
///
/// Displays subscription pricing, user count, badges, and selection state.
///
/// Example:
/// ```dart
/// SubscriptionOptionCard(
///   price: '4 SAR / month',
///   userInfo: '1 User',
///   isMultiUser: false,
///   isSelected: true,
///   badges: [
///     SubscriptionBadge(text: '1st Month Free', position: BadgePosition.left),
///   ],
///   onTap: () => selectOption(),
/// )
/// ```
class SubscriptionOptionCard extends StatelessWidget {
  const SubscriptionOptionCard({
    super.key,
    required this.price,
    required this.userInfo,
    required this.isMultiUser,
    required this.isSelected,
    required this.onTap,
    this.badges = const [],
  });

  final String price;
  final String userInfo;
  final bool isMultiUser;
  final bool isSelected;
  final VoidCallback onTap;
  final List<SubscriptionBadge> badges;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: responsive.scalePadding(
          const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: responsive.scaleBorderRadius(
            BorderRadius.circular(30),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main content row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: Price and user info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Price
                      Text(
                        price,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        softWrap: false,
                        style: AppTypography.headlineSmall.copyWith(
                          fontSize: responsive.scaleFontSize(18, minSize: 16),
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: responsive.scale(8)),
                      // User info row
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMultiUser ? Icons.groups : Icons.person,
                            size: responsive.scale(16),
                            color: theme.colorScheme.onSurface,
                          ),
                          SizedBox(width: responsive.scale(8)),
                          Flexible(
                            child: Text(
                              userInfo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: responsive.scaleFontSize(11.9, minSize: 10),
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurface,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.scale(16)),
                // Right: Radio button
                _RadioButton(isSelected: isSelected),
              ],
            ),
            // Badges positioned absolutely
            ...badges.map((badge) => _buildBadge(context, badge, responsive)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(
    BuildContext context,
    SubscriptionBadge badge,
    ResponsiveHelper responsive,
  ) {
    final theme = Theme.of(context);

    double leftPosition;
    switch (badge.position) {
      case BadgePosition.left:
        leftPosition = responsive.scale(16);
        break;
      case BadgePosition.center:
        leftPosition = responsive.scale(89);
        break;
      case BadgePosition.right:
        leftPosition = responsive.scale(162);
        break;
    }

    return Positioned(
      top: responsive.scale(-13),
      left: leftPosition,
      child: Container(
        padding: responsive.scalePadding(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: responsive.scaleBorderRadius(
            BorderRadius.circular(30),
          ),
        ),
        child: Text(
          badge.text,
          style: badge.isSpecial
              ? const TextStyle(
                  fontFamily: 'Parisienne',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  color: Color(0xFF00FF88), // Bright green
                )
              : AppTypography.labelSmall.copyWith(
                  fontSize: responsive.scaleFontSize(12, minSize: 10),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF00FF88), // Bright green
                  height: 1.33,
                ),
        ),
      ),
    );
  }
}

class _RadioButton extends StatelessWidget {
  const _RadioButton({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Container(
      width: responsive.scale(24),
      height: responsive.scale(24),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: isSelected
            ? null
            : Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
      ),
      child: isSelected
          ? Center(
              child: Icon(
                Icons.check,
                size: responsive.scale(16),
                color: theme.colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}

/// Subscription badge data model
class SubscriptionBadge {
  const SubscriptionBadge({
    required this.text,
    required this.position,
    this.isSpecial = false,
  });

  final String text;
  final BadgePosition position;
  final bool isSpecial; // Uses Parisienne font for "Best Value" badges

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionBadge &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          position == other.position &&
          isSpecial == other.isSpecial;

  @override
  int get hashCode => text.hashCode ^ position.hashCode ^ isSpecial.hashCode;
}

/// Badge position on the card
enum BadgePosition {
  left,   // x: 16
  center, // x: 89
  right,  // x: 162
}
