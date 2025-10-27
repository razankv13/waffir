import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          // Submit button (circular arrow) with animations
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: _handleSubmitTap,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.isValid && !widget.isLoading
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  boxShadow: widget.isValid && !widget.isLoading
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.arrow_forward,
                        color: widget.isValid
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant.withOpacity(0.5),
                        size: 24,
                      ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Phone input field with country selector
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  // Country selector (flag + code + dropdown arrow)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      widget.onCountryTap?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Dropdown arrow
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          // Country flag
                          Text(
                            widget.countryFlag,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          // Country code
                          Text(
                            widget.countryCode,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Vertical divider
                  Container(
                    width: 1,
                    height: 24,
                    color: colorScheme.outline.withOpacity(0.3),
                  ),

                  const SizedBox(width: 12),

                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      enabled: !widget.isLoading,
                      onChanged: widget.onChanged,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
