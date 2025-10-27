import 'package:flutter/material.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/constants/app_spacing.dart';

/// City selector widget for location selection
///
/// Displays a scrollable list of cities with both Arabic and English names.
/// Matches Waffir design system from Figma.
///
/// Example:
/// ```dart
/// CitySelector(
///   cities: saudiCities,
///   selectedCity: selectedCity,
///   onCitySelected: (city) => setState(() => selectedCity = city),
/// )
/// ```
class CitySelector extends StatelessWidget {
  const CitySelector({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onCitySelected,
    this.height = 500,
  });

  final List<CityData> cities;
  final CityData? selectedCity;
  final ValueChanged<CityData> onCitySelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        itemCount: cities.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final city = cities[index];
          final isSelected = selectedCity?.nameEn == city.nameEn;

          return _buildCityItem(context, city, isSelected);
        },
      ),
    );
  }

  Widget _buildCityItem(BuildContext context, CityData city, bool isSelected) {
    return GestureDetector(
      onTap: () => onCitySelected(city),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 5.5,
        ),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : AppColors.blue05,
          borderRadius: BorderRadius.circular(AppSpacing.radiusWaffir),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            city.displayName,
            style: AppTypography.waffirInput.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.blue60,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// City data model
class CityData {
  const CityData({
    required this.nameAr,
    required this.nameEn,
  });

  final String nameAr;
  final String nameEn;

  String get displayName => nameAr.isNotEmpty ? nameAr : nameEn;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityData &&
          runtimeType == other.runtimeType &&
          nameEn == other.nameEn;

  @override
  int get hashCode => nameEn.hashCode;
}

/// Saudi Arabia cities with Arabic and English names
const List<CityData> kSaudiCities = [
  CityData(nameAr: 'الرياض', nameEn: 'Riyadh'),
  CityData(nameAr: 'جدة', nameEn: 'Jeddah'),
  CityData(nameAr: 'مكة', nameEn: 'Mecca'),
  CityData(nameAr: 'المدينة المنورة', nameEn: 'Medina'),
  CityData(nameAr: 'الخبر', nameEn: 'Khobar'),
  CityData(nameAr: 'الدمام', nameEn: 'Dammam'),
  CityData(nameAr: 'تبوك', nameEn: 'Tabuk'),
  CityData(nameAr: 'ابها', nameEn: 'Abha'),
  CityData(nameAr: 'الطائف', nameEn: 'Taif'),
  CityData(nameAr: 'القسيم', nameEn: 'Qassim'),
  CityData(nameAr: 'ينبع', nameEn: 'Yanbu'),
  CityData(nameAr: 'الجبيل', nameEn: 'Jubail'),
  CityData(nameAr: 'نجران', nameEn: 'Najran'),
  CityData(nameAr: 'جيزان', nameEn: 'Jizan'),
  CityData(nameAr: 'حائل', nameEn: 'Hail'),
  CityData(nameAr: 'الأحساء', nameEn: 'Al Ahsa'),
  CityData(nameAr: 'القطيف', nameEn: 'Qatif'),
  CityData(nameAr: 'الخرج', nameEn: 'Al Kharj'),
  CityData(nameAr: 'الباحة', nameEn: 'Al Bahah'),
  CityData(nameAr: 'عرعر', nameEn: 'Arar'),
  CityData(nameAr: 'سكاكا', nameEn: 'Sakaka'),
  CityData(nameAr: 'بريدة', nameEn: 'Buraydah'),
  CityData(nameAr: 'خميس مشيط', nameEn: 'Khamis Mushait'),
  CityData(nameAr: 'حفر الباطن', nameEn: 'Hafar Al Batin'),
  CityData(nameAr: 'الظهران', nameEn: 'Dhahran'),
];

/// Gradient overlay for bottom fade effect
class CityListGradientOverlay extends StatelessWidget {
  const CityListGradientOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
