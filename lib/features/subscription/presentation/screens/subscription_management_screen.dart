import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/core/extensions/datetime_extensions.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';

class SubscriptionManagementScreen extends ConsumerWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final isPremium = ref.watch(isPremiumUserProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: subscriptionState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, ref, error),
        data: (state) => _buildContent(context, ref, state, isPremium),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SubscriptionState state,
    bool isPremium,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubscriptionStatus(context, state, isPremium),
          const SizedBox(height: AppSpacing.xl),
          if (isPremium) ...[
            _buildActiveSubscription(context, state),
            const SizedBox(height: AppSpacing.xl),
          ],
          _buildQuickActions(context, ref, isPremium),
          const SizedBox(height: AppSpacing.xl),
          _buildSubscriptionHistory(context, state),
          const SizedBox(height: AppSpacing.xl),
          _buildManagementOptions(context),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStatus(
    BuildContext context,
    SubscriptionState state,
    bool isPremium,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.1),
                ]
              : [
                  Colors.grey.withValues(alpha: 0.05),
                  Colors.grey.withValues(alpha: 0.1),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPremium 
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isPremium ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 48,
            color: isPremium ? AppColors.primary : Colors.grey,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
          const SizedBox(height: AppSpacing.md),
          Text(
            isPremium ? 'Premium Active' : 'Free Plan',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isPremium ? AppColors.primary : Colors.grey[700],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isPremium
                ? 'You have access to all premium features'
                : 'Upgrade to unlock all premium features',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, duration: 600.ms);
  }

  Widget _buildActiveSubscription(BuildContext context, SubscriptionState state) {
    final activeEntitlements = state.customerInfo?.entitlements.active ?? {};
    
    if (activeEntitlements.isEmpty) return const SizedBox.shrink();

    final entitlement = activeEntitlements.values.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Current Subscription',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSubscriptionDetail('Product', entitlement.productIdentifier),
          const SizedBox(height: AppSpacing.sm),
          _buildSubscriptionDetail(
            'Status',
            entitlement.isActive ? 'Active' : 'Inactive',
          ),
          if (entitlement.expirationDate != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildSubscriptionDetail(
              'Next Billing',
              entitlement.expirationDate != null ? DateTime.parse(entitlement.expirationDate!).toFormattedString() : 'N/A',
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          _buildSubscriptionDetail(
            'Auto Renew',
            entitlement.willRenew ? 'On' : 'Off',
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideX(begin: 0.3, duration: 600.ms);
  }

  Widget _buildSubscriptionDetail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref, bool isPremium) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (!isPremium) ...[
          _buildActionCard(
            icon: Icons.upgrade,
            title: 'Upgrade to Premium',
            subtitle: 'Unlock all premium features',
            onTap: () => _showPaywall(context),
            color: AppColors.primary,
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms)
              .slideX(begin: 0.3, duration: 400.ms),
          const SizedBox(height: AppSpacing.md),
        ],
        _buildActionCard(
          icon: Icons.restore,
          title: 'Restore Purchases',
          subtitle: 'Restore previous purchases',
          onTap: () => _restorePurchases(context, ref),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 400.ms)
            .slideX(begin: 0.3, duration: 400.ms),
        if (isPremium) ...[
          const SizedBox(height: AppSpacing.md),
          _buildActionCard(
            icon: Icons.refresh,
            title: 'Refresh Status',
            subtitle: 'Update subscription status',
            onTap: () => _refreshSubscription(ref),
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideX(begin: 0.3, duration: 400.ms),
        ],
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color ?? AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSubscriptionHistory(BuildContext context, SubscriptionState state) {
    final allPurchases = state.customerInfo?.allPurchasedProductIdentifiers ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purchase History',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (allPurchases.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  color: Colors.grey[400],
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No purchases yet',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          ...allPurchases.map((productId) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    productId,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Purchased',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )),
        ],
      ],
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms)
        .slideY(begin: 0.3, duration: 600.ms);
  }

  Widget _buildManagementOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Subscription',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'To modify or cancel your subscription, please visit your account settings in the App Store or Google Play Store.',
          style: AppTypography.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.secondary(
          onPressed: () => _openSubscriptionManagement(context),
          child: const Text('Open Store Settings'),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: 700.ms, duration: 600.ms)
        .slideY(begin: 0.3, duration: 600.ms);
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Failed to load subscription info',
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              error.toString(),
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton.primary(
              onPressed: () => ref.read(subscriptionNotifierProvider.notifier).refreshData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaywall(BuildContext context) {
    context.push('/subscription/paywall');
  }

  Future<void> _restorePurchases(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(subscriptionNotifierProvider.notifier).restorePurchases();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restore purchases: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _refreshSubscription(WidgetRef ref) {
    ref.read(subscriptionNotifierProvider.notifier).refreshData();
  }

  void _openSubscriptionManagement(BuildContext context) {
    // TODO: Open platform-specific subscription management
    // On iOS: Settings app > Apple ID > Subscriptions
    // On Android: Play Store > Account > Subscriptions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Subscription'),
        content: const Text(
          'Please open your device settings:\n\n'
          'iOS: Settings > Apple ID > Subscriptions\n'
          'Android: Play Store > Account > Subscriptions',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}