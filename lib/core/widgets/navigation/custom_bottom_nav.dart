import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/navigation/models/nav_tab.dart';
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
  const CustomBottomNav({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _backgroundColor = Color(0xFF0F352D);
  static const _activeColor = Color(0xFFFFFFFF);
  static const _inactiveColor = Color(0xFF00FF88);

  /// Dynamic list of navigation tabs to display.
  final List<NavTab> tabs;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback when a tab is tapped.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper.of(context);

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
          padding: responsive.sPadding(const EdgeInsets.fromLTRB(16, 8, 16, 12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              return _NavItem(
                iconPath: tab.iconPath,
                label: tab.label,
                isSelected: index == selectedIndex,
                activeColor: _activeColor,
                inactiveColor: _inactiveColor,
                onTap: () => onTap(index),
              );
            }).toList(),
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
    final responsive = ResponsiveHelper.of(context);
    final targetColor = isSelected ? activeColor : inactiveColor;

    // Figma typography: Parkinsans, 10px, 1.6 height
    final labelStyle = TextStyle(
      fontFamily: 'Parkinsans',
      fontSize: responsive.sFont(10),
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
                  width: responsive.s(24),
                  height: responsive.s(24),
                  child: SvgPicture.asset(
                    iconPath,
                    width: responsive.s(24),
                    height: responsive.s(24),
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

            SizedBox(height: responsive.s(4)), // 4px gap

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
