import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Custom bottom navigation bar matching Figma design specifications
///
/// Design specs (Node 41:1029):
/// - Layout: Full width, anchored to bottom
/// - Background: #0F352D (dark green)
/// - Padding: 8px top, 16px horizontal, 12px bottom
/// - Active text: white (#FFFFFF), Parkinsans Bold (700), 10px
/// - Inactive text: bright green (#00FF88), Parkinsans Medium (500), 10px
/// - Icons: 24x24px SVG
/// - Gap between icon and label: 4px
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key, required this.selectedIndex, required this.onTap});

  static const _backgroundColor = Color(0xFF0F352D);
  static const _activeColor = Color(0xFFFFFFFF);
  static const _inactiveColor = Color(0xFF00FF88);

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    // Full width bottom bar
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _backgroundColor,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Figma padding: 8px top, 16px horizontal, 12px bottom
          padding: responsive.scalePadding(const EdgeInsets.fromLTRB(16, 8, 16, 12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                iconPath: 'assets/icons/nav/hot_deals_icon.svg',
                label: 'Hot Deals',
                isSelected: selectedIndex == 0,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(0),
              ),
              _NavItem(
                iconPath: 'assets/icons/nav/store_icon.svg',
                label: 'Stores',
                isSelected: selectedIndex == 1,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(1),
              ),
              _NavItem(
                iconPath: 'assets/icons/nav/credit_cards_icon.svg',
                label: 'Credit Cards',
                isSelected: selectedIndex == 2,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(2),
              ),
              _NavItem(
                iconPath: 'assets/icons/nav/profile_icon.svg',
                label: 'Profile',
                isSelected: selectedIndex == 3,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
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
    required this.activeColor,
    required this.inactiveColor,
  });

  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final targetColor = isSelected ? activeColor : inactiveColor;

    // Figma typography: Parkinsans, 10px, 1.6 height
    final labelStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.scaleFontSize(10),
      height: 1.6,
      // Active: Bold (700), Inactive: Medium (500)
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      color: targetColor,
    );

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (animated color + subtle selection scale)
            TweenAnimationBuilder<Color?>(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              tween: ColorTween(end: targetColor),
              builder: (context, color, child) {
                return SizedBox(
                  width: responsive.scale(24),
                  height: responsive.scale(24),
                  child: SvgPicture.asset(
                    iconPath,
                    width: responsive.scale(24),
                    height: responsive.scale(24),
                    colorFilter: ColorFilter.mode(color ?? targetColor, BlendMode.srcIn),
                  ),
                );
              },
            )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  // Subtle scale up when active
                  begin: const Offset(1, 1),
                  end: const Offset(1.15, 1.15),
                  duration: 200.ms,
                  curve: Curves.easeOutCubic,
                ),

            SizedBox(height: responsive.scale(4)), // 4px gap

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              style: labelStyle,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
