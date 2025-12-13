import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.isPopular,
    required this.onTap,
  });
  final Package package;
  final bool isSelected;
  final bool isPopular;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final product = package.storeProduct;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            if (isPopular) _buildPopularBadge(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getPackageTitle(),
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _getPackageDescription(),
                            style: AppTypography.bodyMedium.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.priceString,
                          style: AppTypography.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                        Text(
                          _getPricePeriod(),
                          style: AppTypography.bodySmall.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
                if (_hasDiscount()) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildDiscountInfo(),
                ],
                if (_hasTrial()) ...[const SizedBox(height: AppSpacing.md), _buildTrialInfo()],
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child:
                    Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                        )
                        .animate()
                        .scale(begin: const Offset(0.5, 0.5), duration: 300.ms)
                        .fadeIn(duration: 200.ms),
              ),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(end: const Offset(1.02, 1.02), duration: 200.ms);
  }

  Widget _buildPopularBadge() {
    return Positioned(
      top: -8,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.waffirGreen03],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'MOST POPULAR',
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: -0.5, duration: 400.ms),
    );
  }

  Widget _buildDiscountInfo() {
    final discount = _getDiscountPercentage();
    if (discount == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Text(
        'Save $discount%',
        style: AppTypography.labelSmall.copyWith(
          color: Colors.green[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTrialInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Text(
        _getTrialText(),
        style: AppTypography.labelSmall.copyWith(
          color: Colors.blue[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getPackageTitle() {
    switch (package.packageType) {
      case PackageType.weekly:
        return 'Weekly';
      case PackageType.monthly:
        return 'Monthly';
      case PackageType.threeMonth:
        return '3 Months';
      case PackageType.sixMonth:
        return '6 Months';
      case PackageType.annual:
        return 'Annual';
      case PackageType.lifetime:
        return 'Lifetime';
      default:
        return package.storeProduct.title;
    }
  }

  String _getPackageDescription() {
    switch (package.packageType) {
      case PackageType.weekly:
        return 'Billed every week';
      case PackageType.monthly:
        return 'Billed every month';
      case PackageType.threeMonth:
        return 'Billed every 3 months';
      case PackageType.sixMonth:
        return 'Billed every 6 months';
      case PackageType.annual:
        return 'Billed every year';
      case PackageType.lifetime:
        return 'One-time payment';
      default:
        return package.storeProduct.description;
    }
  }

  String _getPricePeriod() {
    switch (package.packageType) {
      case PackageType.weekly:
        return 'per week';
      case PackageType.monthly:
        return 'per month';
      case PackageType.threeMonth:
        return 'per 3 months';
      case PackageType.sixMonth:
        return 'per 6 months';
      case PackageType.annual:
        return 'per year';
      case PackageType.lifetime:
        return 'forever';
      default:
        return '';
    }
  }

  bool _hasDiscount() {
    return package.packageType == PackageType.annual ||
        package.packageType == PackageType.sixMonth ||
        package.packageType == PackageType.threeMonth;
  }

  bool _hasTrial() {
    return package.storeProduct.introductoryPrice != null &&
        package.storeProduct.introductoryPrice!.price == 0;
  }

  String? _getDiscountPercentage() {
    // This would normally be calculated based on comparison with monthly price
    // For demo purposes, showing static discounts
    switch (package.packageType) {
      case PackageType.annual:
        return '50';
      case PackageType.sixMonth:
        return '30';
      case PackageType.threeMonth:
        return '20';
      default:
        return null;
    }
  }

  String _getTrialText() {
    final introPrice = package.storeProduct.introductoryPrice;
    if (introPrice?.price == 0) {
      final periodUnit = introPrice?.periodUnit;
      final numberOfUnits = introPrice?.periodNumberOfUnits ?? 1;

      switch (periodUnit) {
        case PeriodUnit.day:
          return '$numberOfUnits day${numberOfUnits > 1 ? 's' : ''} free';
        case PeriodUnit.week:
          return '$numberOfUnits week${numberOfUnits > 1 ? 's' : ''} free';
        case PeriodUnit.month:
          return '$numberOfUnits month${numberOfUnits > 1 ? 's' : ''} free';
        case PeriodUnit.year:
          return '$numberOfUnits year${numberOfUnits > 1 ? 's' : ''} free';
        default:
          return 'Free trial';
      }
    }
    return 'Free trial';
  }
}
