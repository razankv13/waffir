import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Subscription period tab switcher (Monthly/Yearly)
///
/// A pill-shaped toggle between Monthly and Yearly subscription periods.
///
/// Example:
/// ```dart
/// SubscriptionTabSwitcher(
///   selectedTab: SubscriptionPeriod.monthly,
///   onTabChanged: (period) => setState(() => _selectedPeriod = period),
/// )
/// ```
class SubscriptionTabSwitcher extends StatelessWidget {
  const SubscriptionTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final SubscriptionPeriod selectedTab;
  final ValueChanged<SubscriptionPeriod> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return Container(
      height: responsive.scale(64),
      padding: responsive.scalePadding(const EdgeInsets.all(4)),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: responsive.scaleBorderRadius(
          BorderRadius.circular(9999),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabItem(
            label: 'Monthly',
            isSelected: selectedTab == SubscriptionPeriod.monthly,
            onTap: () => onTabChanged(SubscriptionPeriod.monthly),
            width: responsive.scale(120),
          ),
          _TabItem(
            label: 'Yearly\n(Save more)',
            isSelected: selectedTab == SubscriptionPeriod.yearly,
            onTap: () => onTabChanged(SubscriptionPeriod.yearly),
            width: responsive.scale(120),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.width,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : Colors.transparent,
          borderRadius: responsive.scaleBorderRadius(
            BorderRadius.circular(9999),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: AppTypography.labelLarge.copyWith(
            fontSize: responsive.scaleFontSize(14, minSize: 12),
            fontWeight: FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.surface,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Subscription period enum
enum SubscriptionPeriod {
  monthly,
  yearly,
}
