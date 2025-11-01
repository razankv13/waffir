import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Custom bottom navigation bar matching Figma design specifications
///
/// Design specs:
/// - Background: #0F352D (dark green)
/// - Padding: 8px top, 16px horizontal, 12px bottom
/// - Active text: white (#FFFFFF), Parkinsans Bold (700), 10px
/// - Inactive text: bright green (#00FF88), Parkinsans Medium (500), 10px
/// - Icons: 24x24px SVG
/// - Gap between icon and label: 4px
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0F352D), // Figma: primaryColorDarkest
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(
            iconPath: 'assets/icons/nav/hot_deals_icon.svg',
            label: 'Hot Deals',
            isSelected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            iconPath: 'assets/icons/nav/store_icon.svg',
            label: 'Stores',
            isSelected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            iconPath: 'assets/icons/nav/credit_cards_icon.svg',
            label: 'Credit Cards',
            isSelected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            iconPath: 'assets/icons/nav/profile_icon.svg',
            label: 'Profile',
            isSelected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

/// Individual navigation item with icon and label
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon container (24x24px)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? const Color(0xFFFFFFFF) // White for active
                          : const Color(0xFF00FF88), // Bright green for inactive
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 4), // 4px gap as per Figma
                // Label
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Parkinsans',
                    fontSize: 10,
                    height: 1.6, // Line height 1.6em = 16px
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFFFFFFFF) // White for active
                        : const Color(0xFF00FF88), // Bright green for inactive
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
