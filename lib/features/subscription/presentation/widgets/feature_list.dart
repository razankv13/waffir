import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';

class PremiumFeatureList extends StatelessWidget {
  const PremiumFeatureList({super.key});

  @override
  Widget build(BuildContext context) {
    final features = _getPremiumFeatures();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: AppTypography.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...features
            .asMap()
            .entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PremiumFeatureItem(
                    feature: entry.value,
                    animationDelay: entry.key * 100,
                  ),
                ))
            ,
      ],
    );
  }

  List<PremiumFeature> _getPremiumFeatures() {
    return [
      const PremiumFeature(
        icon: Icons.cloud_sync,
        title: 'Cloud Sync',
        description: 'Sync your data across all devices',
        color: Colors.blue,
      ),
      const PremiumFeature(
        icon: Icons.palette,
        title: 'Premium Themes',
        description: 'Access to exclusive color themes and customizations',
        color: Colors.purple,
      ),
      const PremiumFeature(
        icon: Icons.analytics,
        title: 'Advanced Analytics',
        description: 'Detailed insights and reports about your usage',
        color: Colors.green,
      ),
      const PremiumFeature(
        icon: Icons.backup,
        title: 'Auto Backup',
        description: 'Automatic backup of all your important data',
        color: Colors.orange,
      ),
      const PremiumFeature(
        icon: Icons.security,
        title: 'Enhanced Security',
        description: 'Additional security features and privacy controls',
        color: Colors.red,
      ),
      const PremiumFeature(
        icon: Icons.support_agent,
        title: 'Priority Support',
        description: 'Get help faster with premium customer support',
        color: Colors.teal,
      ),
    ];
  }
}

class PremiumFeatureItem extends StatelessWidget {

  const PremiumFeatureItem({
    super.key,
    required this.feature,
    this.animationDelay = 0,
  });
  final PremiumFeature feature;
  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: feature.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            feature.icon,
            color: feature.color,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                feature.description,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 20,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: animationDelay), duration: 400.ms)
        .slideX(begin: 0.3, duration: 400.ms);
  }
}

class PremiumFeature {

  const PremiumFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String description;
  final Color color;
}