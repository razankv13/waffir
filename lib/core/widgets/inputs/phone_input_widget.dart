import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waffir/core/utils/responsive_helper.dart';
import 'package:waffir/gen/assets.gen.dart';

/// Phone number input widget with country selector
///
/// Features:
/// - Country picker powered by `country_code_picker`
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
///   onCountryChanged: (code) => _updateDialCode(code),
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
    this.onChanged,
    this.onCountryChanged,
  });

  final TextEditingController? controller;
  final String countryCode;
  final String countryFlag;
  final String hintText;
  final bool isLoading;
  final bool isValid;
  final VoidCallback? onSubmit;
  final ValueChanged<String>? onChanged;
  final ValueChanged<CountryCode>? onCountryChanged;

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  CountryCode? _selectedCountryCode;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
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

  void _handleCountryChanged(CountryCode countryCode) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCountryCode = countryCode;
    });
    widget.onCountryChanged?.call(countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = context.responsive;

    double s(double value) => responsive.scaleWithMax(value, max: value); // downscale-only
    double sf(double value, {double min = 10.0}) =>
        responsive.scaleWithRange(value, min: min, max: value); // downscale-only

    return SizedBox(
      height: s(56),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // Submit button (node `I50:3067;50:5593`): 44×44, #0F352D, no shadow.
            ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: _handleSubmitTap,
                child: Container(
                  width: s(44),
                  height: s(44),
                  decoration: BoxDecoration(
                    color: widget.isValid && !widget.isLoading
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(s(1000)),
                  ),
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? SizedBox(
                          width: s(20),
                          height: s(20),
                          child: CircularProgressIndicator(
                            strokeWidth: s(2.0),
                            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurfaceVariant),
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.icons.arrowIcon.path,
                          width: s(24),
                          height: s(24),
                          colorFilter: ColorFilter.mode(
                            widget.isValid ? Colors.white : colorScheme.onSurfaceVariant,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(width: s(16)),

            // Phone input container (node `I50:3067;50:5575`): fill, radius=16, padding=16.
            Expanded(
              child: Container(
                height: s(56),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(s(16)),
                ),
                padding: EdgeInsets.all(s(16)),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      // Flag + dropdown (node `I50:3067;50:5576`): gap=24 between flag-group and number-group.
                      IgnorePointer(
                        ignoring: widget.isLoading,
                        child: CountryCodePicker(
                          onChanged: _handleCountryChanged,
                          onInit: (country) => _selectedCountryCode = country,
                          initialSelection: widget.countryCode,
                          favorite: [widget.countryCode, 'SA'],
                          flagWidth: s(22),
                          padding: EdgeInsets.zero,
                          searchDecoration: InputDecoration(
                            hintText: 'Search country',
                            hintStyle: TextStyle(
                              fontFamily: 'Parkinsans',
                              fontSize: sf(14, min: 12),
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: s(20),
                              color: colorScheme.onSurfaceVariant,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(s(12)),
                              borderSide: BorderSide(color: colorScheme.outlineVariant),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(s(12)),
                              borderSide: BorderSide(color: colorScheme.primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: s(12), vertical: s(8)),
                          ),
                          builder: (country) {
                            final resolvedCountry = country ?? _selectedCountryCode;
                            final dialCode = resolvedCountry?.dialCode ?? widget.countryCode;
                            final flagUri = resolvedCountry?.flagUri;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (flagUri != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(s(3)),
                                    child: Image.asset(
                                      flagUri,
                                      package: 'country_code_picker',
                                      width: s(22),
                                      height: s(15),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else
                                  Text(
                                    widget.countryFlag,
                                    style: TextStyle(
                                      fontFamily: 'Parkinsans',
                                      fontSize: sf(16, min: 12),
                                    ),
                                  ),
                                SizedBox(width: s(8)),
                                SvgPicture.asset(
                                  'assets/icons/chevron_down.svg',
                                  width: s(12),
                                  height: s(12),
                                  colorFilter: ColorFilter.mode(
                                    colorScheme.onSurface,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: s(24)),
                                Text(
                                  dialCode,
                                  style: TextStyle(
                                    fontFamily: 'Parkinsans',
                                    fontSize: sf(14, min: 12),
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(width: s(12)),

                      // Phone number input (node `I50:3067;50:5592`): 14/500 placeholder #A3A3A3.
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          enabled: !widget.isLoading,
                          onChanged: widget.onChanged,
                          style: TextStyle(
                            fontFamily: 'Parkinsans',
                            fontSize: sf(14, min: 12),
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: colorScheme.onSurface,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintTextDirection: TextDirection.ltr,
                            hintStyle: TextStyle(
                              fontFamily: 'Parkinsans',
                              fontSize: sf(14, min: 12),
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              color: const Color(0xFFA3A3A3),
                            ),
                            border: InputBorder.none,
                            fillColor: colorScheme.surfaceContainerHighest,
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
            ),
          ],
        ),
      ),
    );
  }
}
