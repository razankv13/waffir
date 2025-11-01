import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// City list item widget
///
/// Features:
/// - Pill-shaped button design
/// - Selected/unselected states
/// - Border or filled state
/// - 60px border radius
/// - 56px height
/// - Haptic feedback on selection
/// - Material ripple effect
/// - Accessibility support
///
/// Example usage:
/// ```dart
/// CityListItem(
///   cityName: 'الرياض',
///   isSelected: _selectedCity == 'الرياض',
///   onTap: () => _selectCity('الرياض'),
/// )
/// ```
class CityListItem extends StatelessWidget {
  const CityListItem({
    super.key,
    required this.cityName,
    required this.isSelected,
    required this.onTap,
  });

  final String cityName;
  final bool isSelected;
  final VoidCallback onTap;

  void _handleTap() {
    HapticFeedback.selectionClick();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: isSelected
          ? 'مدينة $cityName، محددة'
          : 'اختر مدينة $cityName',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(60),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
                width: isSelected ? 2.5 : 1,
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(
                cityName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.1,
                  color: colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
