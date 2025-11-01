import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Horizontal scrollable category filter chips with icon-above-text layout
///
/// Matches Figma design (node 34:6101) with:
/// - Vertical icon+text layout (column)
/// - Bottom border indicator for selected state (no background fill)
/// - 100px width, 64px height per chip
/// - 24x24px icons with 4px gap
/// - Parkinsans 14px font (700 selected, 500 unselected)
///
/// Example usage:
/// ```dart
/// CategoryFilterChips(
///   categories: ['For You', 'Front Page', 'Popular'],
///   categoryIcons: [
///     'assets/icons/categories/for_you_icon.svg',
///     'assets/icons/categories/front_page_icon.svg',
///     'assets/icons/categories/popular_icon.svg',
///   ],
///   selectedCategory: 'For You',
///   onCategorySelected: (category) => filterProducts(category),
/// )
/// ```
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.categoryIcons,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : assert(
          categories.length == categoryIcons.length,
          'Categories and icons must have the same length',
        );

  final List<String> categories;
  final List<String> categoryIcons;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 21),
        itemBuilder: (context, index) {
          final category = categories[index];
          final iconPath = categoryIcons[index];
          final isSelected = category == selectedCategory;

          return _CategoryChip(
            label: category,
            iconPath: iconPath,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (24x24)
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
            ),

            // Gap between icon and text
            const SizedBox(height: 4),

            // Label Text
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
