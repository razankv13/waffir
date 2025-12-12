import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Phone number input widget with country selector
///
/// Features:
/// - Country flag and code dropdown
/// - Phone number input field
/// - Submit button (circular arrow) with animations
/// - Loading state with spinner
/// - Disabled state when input invalid
/// - Haptic feedback on interactions
/// - Scale animation on button press
/// - RTL support
///
/// Example usage:
/// ```dart
/// PhoneInputWidget(
///   controller: _phoneController,
///   countryCode: '+966',
///   isLoading: false,
///   isValid: true,
///   onSubmit: () => _handlePhoneSubmit(),
///   onCountryTap: () => _showCountryPicker(),
/// )
/// ```
class PhoneInputWidget extends StatefulWidget {
  const PhoneInputWidget({
    super.key,
    this.controller,
    this.countryCode = '+966',
    this.countryFlag = '🇸🇦',
    this.hintText = 'رقم الجوال',
    this.isLoading = false,
    this.isValid = true,
    this.onSubmit,
    this.onCountryTap,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String countryCode;
  final String countryFlag;
  final String hintText;
  final bool isLoading;
  final bool isValid;
  final VoidCallback? onSubmit;
  final VoidCallback? onCountryTap;
  final ValueChanged<String>? onChanged;

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleSubmitTap() {
    if (!widget.isValid || widget.isLoading) return;

    HapticFeedback.lightImpact();
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    widget.onSubmit?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 56,
      child: Row(
        children: [
          // Phone input field with country selector - LEFT per Figma
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.gray01,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Country selector (flag + code + dropdown arrow) - Figma specs
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onCountryTap?.call();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Country flag from Figma assets
                        SvgPicture.asset(
                          Assets.icons.flagSa.path,
                          width: 22,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        // Country code - Parkinsans 14px weight 600
                        Text(
                          widget.countryCode,
                          style: const TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Dropdown arrow
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onSurface,
                          size: 12,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      enabled: !widget.isLoading,
                      onChanged: widget.onChanged,
                      style: const TextStyle(
                        fontFamily: 'Parkinsans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(
                          fontFamily: 'Parkinsans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.64),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        fillColor: AppColors.gray01,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Submit button (circular arrow) with animations - 44x44px per Figma - RIGHT per Figma
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: _handleSubmitTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.isValid && !widget.isLoading
                      ? const Color(0xFF0F352D) // Dark green when valid
                      : const Color(0xFFF2F2F2), // Light gray when invalid
                  shape: BoxShape.circle,
                  boxShadow: widget.isValid && !widget.isLoading
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          Assets.icons.arrowIcon.path,
                          width: 24,
                          height: 24,
                          color: widget.isValid
                              ? Colors.white // White arrow on dark green
                              : const Color(0xFFA3A3A3), // Gray arrow on light gray
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
