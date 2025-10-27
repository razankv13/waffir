import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/navigation/routes.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';

/// A wrapper widget that controls access to premium features
class PremiumFeatureWrapper extends ConsumerWidget {

  const PremiumFeatureWrapper({
    super.key,
    required this.child,
    this.fallback,
    this.featureName,
    this.description,
    this.showUpgradeButton = true,
    this.onUpgradePressed,
  });
  final Widget child;
  final Widget? fallback;
  final String? featureName;
  final String? description;
  final bool showUpgradeButton;
  final VoidCallback? onUpgradePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumUserProvider);

    if (isPremium) {
      return child;
    }

    return fallback ?? _buildDefaultFallback(context);
  }

  Widget _buildDefaultFallback(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            featureName ?? 'Premium Feature',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description ?? 'Upgrade to Premium to unlock this feature',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (showUpgradeButton) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onUpgradePressed ?? () => _showPaywall(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Upgrade to Premium',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    context.push(AppRoutes.paywall);
  }
}

/// A mixin that can be used with ConsumerWidget to add premium feature checks
mixin PremiumFeatureMixin {
  bool isPremiumUser(WidgetRef ref) {
    return ref.watch(isPremiumUserProvider);
  }

  bool hasEntitlement(WidgetRef ref, String entitlementId) {
    return ref.watch(hasActiveSubscriptionProvider(entitlementId));
  }

  void showPaywall(BuildContext context) {
    context.push(AppRoutes.paywall);
  }

  void showSubscriptionManagement(BuildContext context) {
    context.push(AppRoutes.subscriptionManagement);
  }

  Widget buildPremiumBadge({
    String text = 'PRO',
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget buildPremiumListTile({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    bool isPremiumFeature = true,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (isPremiumFeature) ...[
            const SizedBox(width: 8),
            buildPremiumBadge(),
          ],
        ],
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}

/// A premium-aware app bar action
class PremiumAppBarAction extends ConsumerWidget {

  const PremiumAppBarAction({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.requiresPremium = true,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool requiresPremium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumUserProvider);

    return IconButton(
      icon: Stack(
        children: [
          Icon(icon),
          if (requiresPremium && !isPremium)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      onPressed: () {
        if (requiresPremium && !isPremium) {
          context.push(AppRoutes.paywall);
        } else {
          onPressed?.call();
        }
      },
      tooltip: tooltip,
    );
  }
}

/// A floating action button with premium awareness
class PremiumFloatingActionButton extends ConsumerWidget {

  const PremiumFloatingActionButton({
    super.key,
    this.onPressed,
    this.child,
    this.tooltip,
    this.requiresPremium = true,
  });
  final VoidCallback? onPressed;
  final Widget? child;
  final String? tooltip;
  final bool requiresPremium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumUserProvider);

    return FloatingActionButton(
      onPressed: () {
        if (requiresPremium && !isPremium) {
          context.push(AppRoutes.paywall);
        } else {
          onPressed?.call();
        }
      },
      tooltip: tooltip,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child ?? const Icon(Icons.add),
          if (requiresPremium && !isPremium)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  size: 8,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Premium feature dialog
class PremiumFeatureDialog extends StatelessWidget {

  const PremiumFeatureDialog({
    super.key,
    required this.title,
    required this.description,
    required this.features,
  });
  final String title;
  final String description;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.star,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.push(AppRoutes.paywall);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Upgrade Now'),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> features,
  }) {
    showDialog(
      context: context,
      builder: (context) => PremiumFeatureDialog(
        title: title,
        description: description,
        features: features,
      ),
    );
  }
}