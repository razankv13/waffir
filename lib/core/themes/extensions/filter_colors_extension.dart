import 'package:flutter/material.dart';

/// Theme extension for filter/chip component colors.
///
/// Provides semantic colors for selected/unselected filter states,
/// matching Figma design specifications (node 34:6101).
@immutable
class FilterColors extends ThemeExtension<FilterColors> {
  const FilterColors({
    required this.selected,
    required this.unselected,
    required this.selectedBorder,
  });

  /// Color for selected filter text and icons (#00C531 - waffirGreen03)
  final Color selected;

  /// Color for unselected filter text and icons (#A3A3A3 - gray03)
  final Color unselected;

  /// Color for selected filter border indicator (#00C531 - waffirGreen03)
  final Color selectedBorder;

  @override
  FilterColors copyWith({
    Color? selected,
    Color? unselected,
    Color? selectedBorder,
  }) {
    return FilterColors(
      selected: selected ?? this.selected,
      unselected: unselected ?? this.unselected,
      selectedBorder: selectedBorder ?? this.selectedBorder,
    );
  }

  @override
  ThemeExtension<FilterColors> lerp(ThemeExtension<FilterColors>? other, double t) {
    if (other is! FilterColors) return this;
    return FilterColors(
      selected: Color.lerp(selected, other.selected, t) ?? selected,
      unselected: Color.lerp(unselected, other.unselected, t) ?? unselected,
      selectedBorder: Color.lerp(selectedBorder, other.selectedBorder, t) ?? selectedBorder,
    );
  }

  /// Light theme filter colors matching Figma design.
  static FilterColors light() {
    return const FilterColors(
      selected: Color(0xFF00C531), // waffirGreen03
      unselected: Color(0xFFA3A3A3), // gray03
      selectedBorder: Color(0xFF00C531), // waffirGreen03
    );
  }
}
