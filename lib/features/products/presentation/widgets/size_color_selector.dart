import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

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
    final responsive = context.responsive;

    if (availableSizes.isEmpty && availableColors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
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
            SizedBox(height: responsive.scale(12)),
            Wrap(
              spacing: responsive.scale(8),
              runSpacing: responsive.scale(8),
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
            if (availableColors.isNotEmpty) SizedBox(height: responsive.scale(16)),
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
            SizedBox(height: responsive.scale(12)),
            Wrap(
              spacing: responsive.scale(12),
              runSpacing: responsive.scale(12),
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
    final responsive = context.responsive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.scale(8)),
      child: Container(
        width: responsive.scale(48),
        height: responsive.scale(48),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(responsive.scale(8)),
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
    final responsive = context.responsive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.scale(16)),
      child: Container(
        padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(responsive.scale(16)),
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
