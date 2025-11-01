import 'package:flutter/material.dart';

/// A filter chip widget for category selection with RTL support
///
/// Example usage:
/// ```dart
/// CategoryFilterChip(
///   label: 'Fashion',
///   icon: Icons.shopping_bag,
///   isSelected: true,
///   onTap: () => print('Fashion tapped'),
/// )
/// ```
class CategoryFilterChip extends StatelessWidget {
  const CategoryFilterChip({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.height = 64.0,
    this.width = 100.0,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: const Color(0xFF00C531), // Primary green from Figma
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? const Color(0xFF00C531)
                    : const Color(0xFFA3A3A3), // Light gray from Figma
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Parkinsans',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF00C531)
                    : const Color(0xFFA3A3A3),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// A scrollable list of category filter chips
///
/// Example usage:
/// ```dart
/// CategoryFilterChips(
///   categories: [
///     CategoryFilterItem(label: 'All', icon: Icons.apps),
///     CategoryFilterItem(label: 'Fashion', icon: Icons.shopping_bag),
///   ],
///   selectedIndex: 0,
///   onCategorySelected: (index) => print('Selected: $index'),
/// )
/// ```
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    this.height = 64.0,
    this.isRTL = false,
  });

  final List<CategoryFilterItem> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final double height;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: EdgeInsets.only(
                right: isRTL ? 0 : (index == categories.length - 1 ? 0 : 0),
                left: isRTL ? (index == categories.length - 1 ? 0 : 0) : 0,
              ),
              child: CategoryFilterChip(
                label: category.label,
                icon: category.icon,
                isSelected: index == selectedIndex,
                onTap: () => onCategorySelected(index),
                height: height,
                width: category.width ?? 100,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Model class for category filter items
class CategoryFilterItem {
  const CategoryFilterItem({
    required this.label,
    this.icon,
    this.width,
  });

  final String label;
  final IconData? icon;
  final double? width;
}
