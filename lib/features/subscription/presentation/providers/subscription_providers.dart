import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:waffir/core/services/revenue_cat_service.dart' as revenue_cat;
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_status.dart';
import 'package:waffir/features/subscription/domain/utils/package_mapper.dart';
import 'package:waffir/features/subscription/presentation/providers/subscription_selection_provider.dart';
import 'package:waffir/features/subscription/presentation/widgets/subscription_tab_switcher.dart';

// ============================================
// PURCHASE RESULT TYPES
// ============================================

/// Result type for purchase operations
enum PurchaseResultType {
  /// Purchase completed successfully
  success,

  /// User cancelled the purchase
  cancelled,

  /// User already has an active subscription
  alreadySubscribed,

  /// Generic purchase error
  error,

  /// Network-related error
  networkError,

  /// Selected package not available in offerings
  noPackageAvailable,

  /// RevenueCat is not initialized
  notInitialized,
}

/// Result of a purchase operation with details
class SubscriptionPurchaseResult {
  const SubscriptionPurchaseResult({required this.type, this.message, this.customerInfo});

  final PurchaseResultType type;
  final String? message;
  final purchases.CustomerInfo? customerInfo;

  bool get isSuccess => type == PurchaseResultType.success;
  bool get wasCancelled => type == PurchaseResultType.cancelled;
  bool get isError => type == PurchaseResultType.error || type == PurchaseResultType.networkError;
}

// ============================================
// PROVIDERS
// ============================================

/// Provider for RevenueCat service instance
final revenueCatServiceProvider = Provider<revenue_cat.RevenueCatService>((ref) {
  return revenue_cat.RevenueCatService.instance;
});

/// Provider for subscription initialization status
final subscriptionInitializationProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(revenueCatServiceProvider);
  return service.isInitialized;
});

/// Provider for customer info stream
final customerInfoStreamProvider = StreamProvider<purchases.CustomerInfo?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  if (!service.isInitialized) {
    return Stream.value(null);
  }
  return service.customerInfoStream;
});

/// Provider for current customer info
final currentCustomerInfoProvider = Provider<purchases.CustomerInfo?>((ref) {
  // Watch the stream to get reactive updates
  final streamValue = ref.watch(customerInfoStreamProvider);
  return streamValue.value;
});

/// Provider for subscription status with reactive updates
final subscriptionStatusProvider = Provider<SubscriptionStatus>((ref) {
  final customerInfo = ref.watch(currentCustomerInfoProvider);
  if (customerInfo == null) return SubscriptionStatus.unknown;

  final service = ref.read(revenueCatServiceProvider);
  final status = service.getSubscriptionStatus();

  switch (status) {
    case revenue_cat.SubscriptionStatus.unknown:
      return SubscriptionStatus.unknown;
    case revenue_cat.SubscriptionStatus.notSubscribed:
      return SubscriptionStatus.notSubscribed;
    case revenue_cat.SubscriptionStatus.subscribed:
      return SubscriptionStatus.subscribed;
    case revenue_cat.SubscriptionStatus.expired:
      return SubscriptionStatus.expired;
    case revenue_cat.SubscriptionStatus.inGracePeriod:
      return SubscriptionStatus.inGracePeriod;
    case revenue_cat.SubscriptionStatus.inBillingRetry:
      return SubscriptionStatus.inBillingRetry;
  }
});

/// Provider for checking active subscription
final hasActiveSubscriptionProvider = Provider.family<bool, String?>((ref, entitlementId) {
  final customerInfo = ref.watch(currentCustomerInfoProvider);
  if (customerInfo == null) return false;

  if (entitlementId != null) {
    return customerInfo.entitlements.active.containsKey(entitlementId);
  }
  return customerInfo.entitlements.active.isNotEmpty;
});

/// Provider for current offerings
final currentOfferingsProvider = Provider<purchases.Offerings?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.currentOfferings;
});

/// Provider for available products
final availableProductsProvider = Provider<List<purchases.StoreProduct>>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.getAvailableProducts();
});

/// Provider for available packages
final availablePackagesProvider = Provider<List<purchases.Package>>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.getAvailablePackages();
});

/// Provider for premium features check
final isPremiumUserProvider = Provider<bool>((ref) {
  return ref.watch(hasActiveSubscriptionProvider(null));
});

/// Provider to check if RevenueCat is available
final isRevenueCatAvailableProvider = Provider<bool>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.isInitialized;
});

// ============================================
// SUBSCRIPTION NOTIFIER
// ============================================

/// AsyncNotifier for managing subscription state and purchase operations
class SubscriptionNotifier extends AsyncNotifier<SubscriptionState> {
  late revenue_cat.RevenueCatService _revenueCatService;
  StreamSubscription<purchases.CustomerInfo>? _customerInfoSubscription;

  @override
  Future<SubscriptionState> build() async {
    _revenueCatService = ref.read(revenueCatServiceProvider);

    // Set up customer info listener for real-time updates
    _setupCustomerInfoListener();

    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _customerInfoSubscription?.cancel();
    });

    return _loadInitialState();
  }

  /// Set up listener for customer info changes
  void _setupCustomerInfoListener() {
    if (!_revenueCatService.isInitialized) return;

    _customerInfoSubscription = _revenueCatService.customerInfoStream.listen(
      (customerInfo) {
        // Update state when customer info changes
        state = state.whenData((current) => current.copyWith(customerInfo: customerInfo));
        AppLogger.info('Customer info updated via stream');
      },
      onError: (error) {
        AppLogger.error('Customer info stream error', error: error);
      },
    );
  }

  Future<SubscriptionState> _loadInitialState() async {
    if (!_revenueCatService.isInitialized) {
      return const SubscriptionState(
        customerInfo: null,
        offerings: null,
        isLoading: false,
        error: 'RevenueCat not initialized',
      );
    }

    final customerInfo = _revenueCatService.currentCustomerInfo;
    final offerings = _revenueCatService.currentOfferings;

    return SubscriptionState(customerInfo: customerInfo, offerings: offerings);
  }

  /// Refresh subscription data from RevenueCat
  Future<void> refreshData() async {
    if (!_revenueCatService.isInitialized) {
      state = AsyncValue.data(
        state.value?.copyWith(error: 'RevenueCat not initialized') ?? const SubscriptionState(),
      );
      return;
    }

    state = const AsyncValue.loading();
    try {
      await _revenueCatService.refreshCustomerInfo();
      await _revenueCatService.refreshOfferings();

      final customerInfo = _revenueCatService.currentCustomerInfo;
      final offerings = _revenueCatService.currentOfferings;

      state = AsyncValue.data(SubscriptionState(customerInfo: customerInfo, offerings: offerings));
    } catch (error, stackTrace) {
      AppLogger.error('Failed to refresh subscription data', error: error);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Purchase subscription based on UI selection
  ///
  /// This is the main purchase method that handles the complete flow:
  /// 1. Validates RevenueCat is initialized
  /// 2. Checks if user is already subscribed
  /// 3. Finds the appropriate package
  /// 4. Executes the purchase
  /// 5. Handles all error cases
  Future<SubscriptionPurchaseResult> purchaseFromSelection({
    required SubscriptionPeriod period,
    required AppSubscriptionOption option,
  }) async {
    // Check initialization
    if (!_revenueCatService.isInitialized) {
      AppLogger.warning('Attempted purchase but RevenueCat not initialized');
      return const SubscriptionPurchaseResult(
        type: PurchaseResultType.notInitialized,
        message: 'Subscription service is not available',
      );
    }

    // Check if already subscribed to this entitlement
    final currentState = state.value;
    if (currentState != null) {
      final hasEntitlement = PackageMapper.hasEntitlement(currentState.customerInfo, option);
      if (hasEntitlement) {
        AppLogger.info('User already has entitlement for ${option.name}');
        return const SubscriptionPurchaseResult(
          type: PurchaseResultType.alreadySubscribed,
          message: 'You already have an active subscription',
        );
      }
    }

    // Find package from offerings
    final package = PackageMapper.findPackage(
      offerings: _revenueCatService.currentOfferings,
      period: period,
      option: option,
    );

    if (package == null) {
      AppLogger.warning('Package not found for ${period.name} ${option.name}');
      return const SubscriptionPurchaseResult(
        type: PurchaseResultType.noPackageAvailable,
        message: 'Selected subscription plan is not available',
      );
    }

    // Set loading state
    state = state.whenData((current) => current.copyWith(isLoading: true));

    try {
      AppLogger.info('Initiating purchase for package: ${package.identifier}');
      final customerInfo = await _revenueCatService.purchasePackage(package);

      // Update state with new customer info
      state = AsyncValue.data(
        SubscriptionState(
          customerInfo: customerInfo,
          offerings: _revenueCatService.currentOfferings,
          isLoading: false,
        ),
      );

      AppLogger.info('Purchase successful for ${package.identifier}');
      return SubscriptionPurchaseResult(
        type: PurchaseResultType.success,
        customerInfo: customerInfo,
      );
    } on revenue_cat.PurchaseCancelledException {
      AppLogger.info('Purchase cancelled by user');
      state = state.whenData((current) => current.copyWith(isLoading: false));
      return const SubscriptionPurchaseResult(
        type: PurchaseResultType.cancelled,
        message: 'Purchase was cancelled',
      );
    } on revenue_cat.PurchaseFailedException catch (e) {
      AppLogger.error('Purchase failed', error: e);
      state = state.whenData((current) => current.copyWith(isLoading: false, error: e.message));

      // Check for network-related errors
      final isNetworkError =
          e.message.toLowerCase().contains('network') ||
          e.message.toLowerCase().contains('connection') ||
          e.message.toLowerCase().contains('internet');

      return SubscriptionPurchaseResult(
        type: isNetworkError ? PurchaseResultType.networkError : PurchaseResultType.error,
        message: e.message,
      );
    } catch (e) {
      AppLogger.error('Unexpected purchase error', error: e);
      state = state.whenData((current) => current.copyWith(isLoading: false, error: e.toString()));
      return SubscriptionPurchaseResult(
        type: PurchaseResultType.error,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Restore previous purchases with result handling
  Future<SubscriptionPurchaseResult> restorePurchasesWithResult() async {
    if (!_revenueCatService.isInitialized) {
      return const SubscriptionPurchaseResult(
        type: PurchaseResultType.notInitialized,
        message: 'Subscription service is not available',
      );
    }

    state = state.whenData((current) => current.copyWith(isLoading: true));

    try {
      AppLogger.info('Restoring purchases...');
      final customerInfo = await _revenueCatService.restorePurchases();

      state = AsyncValue.data(
        SubscriptionState(
          customerInfo: customerInfo,
          offerings: _revenueCatService.currentOfferings,
          isLoading: false,
        ),
      );

      final hasActiveSubscription = customerInfo.entitlements.active.isNotEmpty;

      if (hasActiveSubscription) {
        AppLogger.info('Purchases restored successfully with active subscription');
        return SubscriptionPurchaseResult(
          type: PurchaseResultType.success,
          message: 'Purchases restored successfully',
          customerInfo: customerInfo,
        );
      } else {
        AppLogger.info('Restore completed but no active subscriptions found');
        return SubscriptionPurchaseResult(
          type: PurchaseResultType.error,
          message: 'No previous purchases found',
          customerInfo: customerInfo,
        );
      }
    } on revenue_cat.RestoreFailedException catch (e) {
      AppLogger.error('Restore failed', error: e);
      state = state.whenData((current) => current.copyWith(isLoading: false, error: e.message));
      return SubscriptionPurchaseResult(type: PurchaseResultType.error, message: e.message);
    } catch (e) {
      AppLogger.error('Unexpected restore error', error: e);
      state = state.whenData((current) => current.copyWith(isLoading: false, error: e.toString()));
      return SubscriptionPurchaseResult(
        type: PurchaseResultType.error,
        message: 'Failed to restore purchases',
      );
    }
  }

  /// Purchase a specific package (legacy method for compatibility)
  Future<bool> purchasePackage(purchases.Package package) async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));

      await _revenueCatService.purchasePackage(package);

      // Refresh data after successful purchase
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData(
        (current) => current.copyWith(isLoading: false, error: error.toString()),
      );
      return false;
    }
  }

  /// Purchase a specific product (legacy method for compatibility)
  Future<bool> purchaseProduct(purchases.StoreProduct product) async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));

      await _revenueCatService.purchaseProduct(product);

      // Refresh data after successful purchase
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData(
        (current) => current.copyWith(isLoading: false, error: error.toString()),
      );
      return false;
    }
  }

  /// Restore purchases (legacy method for compatibility)
  Future<bool> restorePurchases() async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));

      await _revenueCatService.restorePurchases();

      // Refresh data after restore
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData(
        (current) => current.copyWith(isLoading: false, error: error.toString()),
      );
      return false;
    }
  }

  /// Clear any error state
  void clearError() {
    state = state.whenData((current) => current.copyWith(error: null));
  }

  /// Check if a plan change is possible
  bool canChangePlan({
    required SubscriptionPeriod newPeriod,
    required AppSubscriptionOption newOption,
  }) {
    final customerInfo = state.value?.customerInfo;
    if (customerInfo == null) return true; // No current subscription

    // Check if already on this exact plan
    final currentEntitlements = customerInfo.entitlements.active;
    if (currentEntitlements.isEmpty) return true;

    // Implementation depends on your business logic
    // Generally, upgrades are always allowed, downgrades may have restrictions
    return true;
  }
}

/// Provider for subscription state notifier
final subscriptionNotifierProvider = AsyncNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  () {
    return SubscriptionNotifier();
  },
);

// ============================================
// SUBSCRIPTION STATE
// ============================================

/// Data class for subscription state
class SubscriptionState {
  const SubscriptionState({this.customerInfo, this.offerings, this.isLoading = false, this.error});

  final purchases.CustomerInfo? customerInfo;
  final purchases.Offerings? offerings;
  final bool isLoading;
  final String? error;

  SubscriptionState copyWith({
    purchases.CustomerInfo? customerInfo,
    purchases.Offerings? offerings,
    bool? isLoading,
    String? error,
  }) {
    return SubscriptionState(
      customerInfo: customerInfo ?? this.customerInfo,
      offerings: offerings ?? this.offerings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasActiveSubscription {
    return customerInfo?.entitlements.active.isNotEmpty ?? false;
  }

  bool get isPremiumUser {
    return hasActiveSubscription;
  }

  bool get hasError => error != null && error!.isNotEmpty;

  List<purchases.Package> get availablePackages {
    return offerings?.current?.availablePackages ?? [];
  }

  List<purchases.StoreProduct> get availableProducts {
    return availablePackages.map((package) => package.storeProduct).toList();
  }
}
