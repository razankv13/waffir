import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:waffir/core/constants/locale_keys.dart';
import 'package:waffir/core/utils/responsive_helper.dart';

/// Gender options enum
enum Gender {
  male,
  female,
}

/// Gender selector widget with rounded square checkboxes
///
/// Features:
/// - Male/Female selection with rounded square checkboxes
/// - Material 3 compliant styling
/// - Theme-based coloring (no hardcoded colors)
/// - RTL support for Arabic layouts
/// - Internationalized labels via easy_localization
/// - Selected state: filled primary color with white checkmark
/// - Unselected state: border only with transparent fill
///
/// Example usage:
/// ```dart
/// GenderSelector(
///   selectedGender: Gender.male,
///   onChanged: (gender) => setState(() => _selectedGender = gender),
/// )
/// ```
///
/// To override default translations, use custom labels:
/// ```dart
/// GenderSelector(
///   selectedGender: Gender.male,
///   onChanged: (gender) => setState(() => _selectedGender = gender),
///   maleLabel: 'Custom Male',
///   femaleLabel: 'Custom Female',
/// )
/// ```
class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.maleLabel,
    this.femaleLabel,
    this.optionGap,
    this.controlGap,
  });

  final Gender? selectedGender;
  final ValueChanged<Gender> onChanged;

  /// Custom label for male option. If null, uses translated value from LocaleKeys.
  final String? maleLabel;

  /// Custom label for female option. If null, uses translated value from LocaleKeys.
  final String? femaleLabel;
  final double? optionGap;
  final double? controlGap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveHelper(context);
    final double computedOptionGap = optionGap ?? responsive.scale(80);
    final double computedControlGap = controlGap ?? responsive.scale(10);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: responsive.scaleFontSize(16, minSize: 14),
      fontWeight: FontWeight.w400,
      height: 1,
      color: colorScheme.onSurface,
    );

    // Use provided labels or fall back to translated values
    final effectiveMaleLabel = maleLabel ?? LocaleKeys.common.gender.male.tr();
    final effectiveFemaleLabel =
        femaleLabel ?? LocaleKeys.common.gender.female.tr();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Female option (right side in RTL)
        GestureDetector(
          onTap: () => onChanged(Gender.female),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RoundedSquareCheckbox(
                isSelected: selectedGender == Gender.female,
                colorScheme: colorScheme,
              ),
              SizedBox(width: computedControlGap),
              Text(
                effectiveFemaleLabel,
                style: textStyle,
              ),
            ],
          ),
        ),

        SizedBox(width: computedOptionGap),

        // Male option (left side in RTL)
        GestureDetector(
          onTap: () => onChanged(Gender.male),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _RoundedSquareCheckbox(
                isSelected: selectedGender == Gender.male,
                colorScheme: colorScheme,
              ),
              SizedBox(width: computedControlGap),
              Text(
                effectiveMaleLabel,
                style: textStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom rounded square checkbox widget
///
/// Creates a Material 3 compliant checkbox with:
/// - Rounded square shape (24x24 with 4px border radius)
/// - Selected state: Primary color fill with white checkmark
/// - Unselected state: Outline border with transparent fill
/// - Smooth visual transitions
class _RoundedSquareCheckbox extends StatelessWidget {
  const _RoundedSquareCheckbox({
    required this.isSelected,
    required this.colorScheme,
  });

  final bool isSelected;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final double boxSize = responsive.scaleWithRange(24, min: 20, max: 28);
    final double borderWidth = responsive.scaleWithRange(2, min: 1.5, max: 2.5);
    final double iconSize = responsive.scaleWithRange(12.15, min: 10, max: 14);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        borderRadius: responsive.scaleBorderRadius(BorderRadius.circular(4)),
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: colorScheme.primary,
          width: borderWidth,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: iconSize,
              color: colorScheme.secondary,
            )
          : null,
    );
  }
}
