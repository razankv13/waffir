import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/app_spacing.dart';

/// Phone number input widget with country code selector
///
/// Matches Waffir design system with RTL support, country flag,
/// and rounded blue background.
///
/// Example:
/// ```dart
/// PhoneNumberInput(
///   controller: phoneController,
///   onChanged: (value) => print(value),
///   onCountryTap: () => showCountryPicker(),
/// )
/// ```
class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCountryTap,
    this.countryCode = '+966',
    this.countryFlag = '🇸🇦',
    this.hintText = 'رقم الجوال',
    this.validator,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCountryTap;
  final String countryCode;
  final String countryFlag;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.gray01,
        borderRadius: BorderRadius.circular(AppSpacing.radiusWaffir),
      ),
      child: Row(
        children: [
          // Action button (left side - RTL, so shows on right in LTR view)
          _buildActionButton(context),

          const SizedBox(width: 8),

          // Input field container
          Expanded(
            child: _buildInputField(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return GestureDetector(
      onTap: onCountryTap,
      child: Container(
        width: 60,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusWaffir),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_circle_up_rounded,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          // Country selector
          _buildCountrySelector(context),

          const SizedBox(width: 12),

          // Phone number input
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              onChanged: onChanged,
              validator: validator,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr, // Phone numbers are LTR
              textAlign: TextAlign.right,
              style: AppTypography.waffirInput.copyWith(
                color: AppColors.textSecondary,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.waffirInput.copyWith(
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySelector(BuildContext context) {
    return GestureDetector(
      onTap: onCountryTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown arrow
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: AppColors.textSecondary,
            ),

            const SizedBox(width: 4),

            // Country flag
            Text(
              countryFlag,
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(width: 8),

            // Country code
            Text(
              countryCode,
              style: AppTypography.waffirInput.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Country data model for picker
class CountryData {
  const CountryData({
    required this.name,
    required this.code,
    required this.dialCode,
    required this.flag,
  });

  final String name;
  final String code;
  final String dialCode;
  final String flag;
}

/// Common Saudi Arabia cities with both Arabic and English names
const List<CountryData> kSaudiCities = [
  CountryData(name: 'Saudi Arabia', code: 'SA', dialCode: '+966', flag: '🇸🇦'),
  CountryData(name: 'United Arab Emirates', code: 'AE', dialCode: '+971', flag: '🇦🇪'),
  CountryData(name: 'Kuwait', code: 'KW', dialCode: '+965', flag: '🇰🇼'),
  CountryData(name: 'Qatar', code: 'QA', dialCode: '+974', flag: '🇶🇦'),
  CountryData(name: 'Bahrain', code: 'BH', dialCode: '+973', flag: '🇧🇭'),
  CountryData(name: 'Oman', code: 'OM', dialCode: '+968', flag: '🇴🇲'),
];
