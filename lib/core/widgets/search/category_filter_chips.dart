import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/filter_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Horizontal category filter chips with icon-above-text layout
///
/// Matches Figma design (node 34:6101) with:
/// - Row layout with equally spaced chips (Expanded)
/// - Vertical icon+text layout (column)
/// - Bottom border indicator for selected state (no background fill)
/// - 64px height per chip
/// - 24x24px icons with 4px gap
/// - 14px font (700 selected, 500 unselected)
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
    this.categoryLabels,
  }) : assert(
         categories.length == categoryIcons.length,
         'Categories and icons must have the same length',
       ),
       assert(
         categoryLabels == null || categoryLabels.length == categories.length,
         'Category labels, categories, and icons must have the same length',
       );

  final List<String> categories;
  final List<String> categoryIcons;
  final List<String>? categoryLabels;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final displayLabels = categoryLabels ?? categories;

    return Padding(
      padding: responsive.scalePadding(const EdgeInsets.symmetric(horizontal: 16)),
      child: Row(
        children: List.generate(categories.length, (index) {
          final category = categories[index];
          final label = displayLabels[index];
          final iconPath = categoryIcons[index];
          final isSelected = category == selectedCategory;

          return Expanded(
            child: _CategoryChip(
              label: label, 
              iconPath: iconPath,
              isSelected: isSelected,
              onTap: () => onCategorySelected(category),
            ),
          );
        }),
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
    final filterColors = theme.extension<FilterColors>()!;
    final responsive = context.responsive;

    final verticalPadding = responsive.scale(8);
    final iconSize = responsive.scaleWithMin(24, min: 20);
    final gap = responsive.scale(4);
    final fontSize = responsive.scaleFontSize(14, minSize: 11);
    final borderWidth = responsive.scaleWithMin(2, min: 2);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content area with consistent padding for both states
          Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    colorFilter: ColorFilter.mode(
                      isSelected ? filterColors.selected : filterColors.unselected,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(height: gap),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? filterColors.selected : filterColors.unselected,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Underline indicator - always present, transparent when unselected
          Container(
            height: borderWidth,
            color: isSelected ? filterColors.selectedBorder : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
