import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:waffir/core/constants/app_colors.dart';
import 'package:waffir/core/constants/app_spacing.dart';
import 'package:waffir/core/constants/app_typography.dart';
import 'package:waffir/core/widgets/widgets.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_card.dart';
import 'package:waffir/features/subscription/presentation/widgets/feature_list.dart';
import 'package:waffir/features/subscription/presentation/widgets/pricing_toggle.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _showAnnualPlans = true;
  Package? _selectedPackage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final availablePackages = ref.watch(availablePackagesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _restorePurchases,
            child: Text(
              'Restore',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: subscriptionState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
        data: (state) => _buildPaywallContent(context, availablePackages),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildPaywallContent(BuildContext context, List<Package> packages) {
    final filteredPackages = _filterPackagesByType(packages);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: AppSpacing.xl),
          const PremiumFeatureList(),
          const SizedBox(height: AppSpacing.xl),
          PricingToggle(
            showAnnual: _showAnnualPlans,
            onToggle: (showAnnual) {
              setState(() {
                _showAnnualPlans = showAnnual;
                _selectedPackage = null;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSubscriptionCards(filteredPackages),
          const SizedBox(height: AppSpacing.xl),
          _buildTermsAndPrivacy(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.star_rounded,
            size: 60,
            color: AppColors.primary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Unlock Premium Features',
          style: AppTypography.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Get access to all premium features and enhance your experience',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, duration: 600.ms),
      ],
    );
  }

  Widget _buildSubscriptionCards(List<Package> packages) {
    return Column(
      children: packages
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SubscriptionCard(
                  package: entry.value,
                  isSelected: _selectedPackage == entry.value,
                  isPopular: _isPopularPackage(entry.value),
                  onTap: () => _selectPackage(entry.value),
                ),
              ))
          .toList()
          .animate(interval: 100.ms)
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.3, duration: 400.ms),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedPackage != null) ...[
            AppButton.primary(
              onPressed: _isLoading ? null : _purchaseSelected,
              isLoading: _isLoading,
              child: Text(
                'Start Free Trial',
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            AppButton.primary(
              child: Text(
                'Select a Plan',
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

  Widget _buildTermsAndPrivacy() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          'By continuing, you agree to our ',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: _showTermsOfService,
          child: Text(
            'Terms of Service',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          ' and ',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: _showPrivacyPolicy,
          child: Text(
            'Privacy Policy',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Failed to load subscription options',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            error.toString(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.secondary(
            onPressed: () => ref.read(subscriptionNotifierProvider.notifier).refreshData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<Package> _filterPackagesByType(List<Package> packages) {
    if (_showAnnualPlans) {
      return packages
          .where((p) => 
              p.packageType == PackageType.annual ||
              p.packageType == PackageType.sixMonth ||
              p.packageType == PackageType.threeMonth)
          .toList();
    } else {
      return packages
          .where((p) => 
              p.packageType == PackageType.monthly ||
              p.packageType == PackageType.weekly)
          .toList();
    }
  }

  bool _isPopularPackage(Package package) {
    return package.packageType == PackageType.annual;
  }

  void _selectPackage(Package package) {
    setState(() {
      _selectedPackage = package;
    });
  }

  Future<void> _purchaseSelected() async {
    if (_selectedPackage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref
          .read(subscriptionNotifierProvider.notifier)
          .purchasePackage(_selectedPackage!);

      if (success && mounted) {
        _showSuccessDialog();
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar('Purchase failed: ${error.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ref
          .read(subscriptionNotifierProvider.notifier)
          .restorePurchases();

      if (success && mounted) {
        _showSuccessDialog();
      } else if (mounted) {
        _showErrorSnackbar('No purchases to restore');
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar('Restore failed: ${error.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to Premium!'),
        content: const Text('Your subscription is now active. Enjoy all the premium features!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              context.pop(); // Go back to previous screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showTermsOfService() {
    // TODO: Implement terms of service dialog/screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text('Terms of Service content goes here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Implement privacy policy dialog/screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy Policy content goes here...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}