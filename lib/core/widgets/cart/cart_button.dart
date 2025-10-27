import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Floating cart button with item count badge
///
/// Example usage:
/// ```dart
/// CartButton(
///   itemCount: 3,
///   onTap: () => navigateToCart(),
/// )
/// ```
class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.itemCount,
    required this.onTap,
    this.size = CartButtonSize.medium,
  });

  final int itemCount;
  final VoidCallback onTap;
  final CartButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine sizes
    double iconSize;
    double buttonSize;
    double badgeSize;

    switch (size) {
      case CartButtonSize.small:
        iconSize = 20;
        buttonSize = 40;
        badgeSize = 16;
        break;
      case CartButtonSize.medium:
        iconSize = 24;
        buttonSize = 48;
        badgeSize = 18;
        break;
      case CartButtonSize.large:
        iconSize = 28;
        buttonSize = 56;
        badgeSize = 20;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cart Button
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outline,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: iconSize,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        // Item Count Badge
        if (itemCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: BoxConstraints(minWidth: badgeSize),
              height: badgeSize,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surface,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: AppTypography.badgeText.copyWith(
                    color: colorScheme.onError,
                    fontSize: size == CartButtonSize.small ? 8 : 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Cart button sizes
enum CartButtonSize {
  small,
  medium,
  large,
}

/// App bar cart icon button (for use in AppBar)
class AppBarCartButton extends StatelessWidget {
  const AppBarCartButton({
    super.key,
    required this.itemCount,
    required this.onTap,
  });

  final int itemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined),
          onPressed: onTap,
        ),
        if (itemCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16),
              height: 16,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  itemCount > 9 ? '9+' : itemCount.toString(),
                  style: AppTypography.badgeText.copyWith(
                    color: colorScheme.onError,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
