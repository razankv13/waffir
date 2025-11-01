import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/constants/app_colors.dart';

/// Stores category filter chips with exact Figma specifications
///
/// Specifications from Figma:
/// - Container Height: 64px
/// - Chip Width: 100px (fixed)
/// - Selected: Bottom border 2px #00C531, green text, weight 700
/// - Unselected: No border, gray text (#A3A3A3), weight 500
/// - Icons: 24x24px per category
/// - Layout: Vertical (Icon + 4px gap + Text)
/// - Gap between chips: 0px (seamless scroll)
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
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

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
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return _CategoryChip(
            label: category,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Fixed width per Figma
        padding: const EdgeInsets.symmetric(
          horizontal: 9.127, // Exact from Figma
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.primaryColorDark, // #00C531 bright green
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (24x24px)
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.primaryColorDark : AppColors.gray03,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(height: 4), // 4px gap per Figma

            // Label
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primaryColorDark : AppColors.gray03,
                height: 1.4, // Line height from Figma
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
