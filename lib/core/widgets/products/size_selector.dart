import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';

/// Size selector widget for product size selection (S, M, L, XL, etc.)
///
/// Example usage:
/// ```dart
/// SizeSelector(
///   sizes: ['S', 'M', 'L', 'XL', 'XXL'],
///   selectedSize: 'M',
///   onSizeSelected: (size) => print('Selected: $size'),
/// )
/// ```
class SizeSelector extends StatelessWidget {
  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    this.unavailableSizes = const [],
  });

  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;
  final List<String> unavailableSizes;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((size) {
        final bool isSelected = selectedSize == size;
        final bool isAvailable = !unavailableSizes.contains(size);

        return _SizeChip(
          size: size,
          isSelected: isSelected,
          isAvailable: isAvailable,
          onTap: isAvailable ? () => onSizeSelected(size) : null,
        );
      }).toList(),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.size,
    required this.isSelected,
    required this.isAvailable,
    this.onTap,
  });

  final String size;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (!isAvailable) {
      // Unavailable state
      backgroundColor = colorScheme.surface;
      borderColor = colorScheme.outlineVariant;
      textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
    } else if (isSelected) {
      // Selected state
      backgroundColor = colorScheme.primary;
      borderColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
    } else {
      // Default state
      backgroundColor = colorScheme.surface;
      borderColor = colorScheme.outline;
      textColor = colorScheme.onSurface;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: AppTypography.labelLarge.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
