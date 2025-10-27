import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

class PricingToggle extends StatelessWidget {

  const PricingToggle({
    super.key,
    required this.showAnnual,
    required this.onToggle,
  });
  final bool showAnnual;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              text: 'Monthly',
              isSelected: !showAnnual,
              onTap: () => onToggle(false),
            ),
          ),
          Expanded(
            child: _buildToggleOption(
              text: 'Annual',
              isSelected: showAnnual,
              onTap: () => onToggle(true),
              badge: 'Save 50%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Text(
                text,
                style: AppTypography.labelLarge.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (badge != null && isSelected)
              Positioned(
                top: -8,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    badge,
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 100.ms, duration: 300.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 300.ms),
              ),
          ],
        ),
      )
          .animate(target: isSelected ? 1 : 0)
          .scale(end: const Offset(1.02, 1.02), duration: 200.ms),
    );
  }
}