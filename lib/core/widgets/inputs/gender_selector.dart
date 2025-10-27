import 'package:flutter/material.dart';

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
/// - Configurable labels
/// - Selected state: filled primary color with white checkmark
/// - Unselected state: border only with transparent fill
///
/// Example usage:
/// ```dart
/// GenderSelector(
///   selectedGender: Gender.male,
///   onChanged: (gender) => setState(() => _selectedGender = gender),
///   maleLabel: 'ذكر',
///   femaleLabel: 'أنثى',
/// )
/// ```
class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.maleLabel = 'ذكر',
    this.femaleLabel = 'أنثى',
  });

  final Gender? selectedGender;
  final ValueChanged<Gender> onChanged;
  final String maleLabel;
  final String femaleLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Female option (right side in RTL)
        GestureDetector(
          onTap: () => onChanged(Gender.female),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                femaleLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              _RoundedSquareCheckbox(
                isSelected: selectedGender == Gender.female,
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),

        const SizedBox(width: 80),

        // Male option (left side in RTL)
        GestureDetector(
          onTap: () => onChanged(Gender.male),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                maleLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              _RoundedSquareCheckbox(
                isSelected: selectedGender == Gender.male,
                colorScheme: colorScheme,
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
/// - Rounded square shape (24x24 with 6px border radius)
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: 16,
              color: colorScheme.onPrimary,
            )
          : null,
    );
  }
}
