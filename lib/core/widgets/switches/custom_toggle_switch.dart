import 'package:flutter/material.dart';

/// A custom toggle switch widget matching the Figma design
///
/// Figma Specifications:
/// - Total size: 52×32px
/// - Knob size: 28×28px
/// - Padding: 2px
/// - Active color: #00C531
/// - Inactive color: #F2F2F2
/// - Knob shadow: 0px 2px 5px 0px rgba(27, 27, 27, 0.25)
///
/// Example usage:
/// ```dart
/// CustomToggleSwitch(
///   value: true,
///   onChanged: (value) => setState(() => isEnabled = value),
/// )
/// ```
class CustomToggleSwitch extends StatelessWidget {
  const CustomToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 52.0,
    this.height = 32.0, // Exact Figma height
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: width, // 52px exact from Figma
        height: height, // 32px exact from Figma
        decoration: BoxDecoration(
          color: value ? const Color(0xFF00C531) : const Color(0xFFF2F2F2), // Exact Figma colors
          borderRadius: BorderRadius.circular(9999), // Pill shape
        ),
        padding: const EdgeInsets.all(2), // Exact 2px padding from Figma
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: 28, // Exact 28px knob from Figma
            height: 28, // Exact 28px knob from Figma
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // Exact shadow from Figma: 0px 2px 5px 0px rgba(27, 27, 27, 0.25)
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(27, 27, 27, 0.25),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

