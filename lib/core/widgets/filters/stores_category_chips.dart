import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/themes/extensions/filter_colors_extension.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Stores category filter chips with horizontal scroll
///
/// Matches Figma design (node 35:2553) with:
/// - Horizontal scrollable list for 10 categories
/// - Vertical icon+text layout (column)
/// - Bottom border indicator for selected state
/// - 100px width, 64px height per chip
/// - 24x24px icons with 4px gap
/// - 14px font (700 selected, 500 unselected)
///
/// Example usage:
/// ```dart
/// StoresCategoryChips(
///   categories: ['All', 'Dining', 'Fashion', ...],
///   selectedCategory: 'Fashion',
///   onCategorySelected: (category) => filterStores(category),
/// )
/// ```
class StoresCategoryChips extends StatelessWidget {
  const StoresCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.labelBuilder,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final String Function(String category)? labelBuilder;

  /// Maps category names to their icon paths
  String _getIconPath(String category) {
    final Map<String, String> iconMap = {
      'All': 'assets/icons/categories/waffir_icon.svg',
      'Dining': 'assets/icons/categories/dining_icon.svg',
      'Fashion': 'assets/icons/categories/fashion_icon.svg',
      'Electronics': 'assets/icons/categories/electronics_icon.svg',
      'Beauty': 'assets/icons/categories/beauty_icon.svg',
      'Entertainment': 'assets/icons/categories/entertainment_icon.svg',
      'Lifestyle': 'assets/icons/categories/lifestyle_icon.svg',
      'Jewelry': 'assets/icons/categories/jewelry_icon.svg',
      'Travel': 'assets/icons/categories/travel_icon.svg',
      'Other': 'assets/icons/categories/more_icon.svg',
    };
    return iconMap[category] ?? 'assets/icons/categories/more_icon.svg';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.rs;

    return SizedBox(
      height: responsive.s(71),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: responsive.sPadding(const EdgeInsets.symmetric(horizontal: 16)),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final displayLabel = labelBuilder?.call(category) ?? category;

          return _CategoryChip(
            label: displayLabel,
            iconPath: _getIconPath(category),
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
    final filterColors = theme.extension<FilterColors>()!;
    final responsive = context.rs;

    final chipWidth = responsive.s(100);
    final verticalPadding = responsive.s(8);
    final horizontalPadding = responsive.s(9.127);
    final iconSize = responsive.s(24);
    final gap = responsive.s(4);
    final fontSize = responsive.sFont(14, minSize: 11);
    final borderWidth = responsive.s(2);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: chipWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Content area with consistent padding for both states
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
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
                      height: 1.4,
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
      ),
    );
  }
}
