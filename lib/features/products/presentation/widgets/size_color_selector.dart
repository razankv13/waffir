import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Size and color selector widget for product variants
class SizeColorSelector extends StatelessWidget {
  const SizeColorSelector({
    super.key,
    this.availableSizes = const [],
    this.availableColors = const [],
    this.selectedSize,
    this.selectedColor,
    this.onSizeSelected,
    this.onColorSelected,
  });

  final List<String> availableSizes;
  final List<String> availableColors;
  final String? selectedSize;
  final String? selectedColor;
  final Function(String)? onSizeSelected;
  final Function(String)? onColorSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (availableSizes.isEmpty && availableColors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Size selector
          if (availableSizes.isNotEmpty) ...[
            Text(
              'Size',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableSizes.map((size) {
                final isSelected = size == selectedSize;
                return _SizeChip(
                  label: size,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSizeSelected?.call(size);
                  },
                );
              }).toList(),
            ),
            if (availableColors.isNotEmpty) const SizedBox(height: 16),
          ],

          // Color selector
          if (availableColors.isNotEmpty) ...[
            Text(
              'Color',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableColors.map((color) {
                final isSelected = color == selectedColor;
                return _ColorChip(
                  label: color,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onColorSelected?.call(color);
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Size chip widget
class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// Color chip widget
class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
