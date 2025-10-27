import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:waffir/features/subscription/domain/entities/subscription_status.dart';
import 'package:waffir/core/services/revenue_cat_service.dart' as revenue_cat;

// Provider for RevenueCat service instance
final revenueCatServiceProvider = Provider<revenue_cat.RevenueCatService>((ref) {
  return revenue_cat.RevenueCatService.instance;
});

// Provider for subscription initialization status
final subscriptionInitializationProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(revenueCatServiceProvider);
  return service.isInitialized;
});

// Provider for customer info stream
final customerInfoStreamProvider = StreamProvider<purchases.CustomerInfo?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  if (!service.isInitialized) {
    return Stream.value(null);
  }
  return service.customerInfoStream;
});

// Provider for current customer info
final currentCustomerInfoProvider = Provider<purchases.CustomerInfo?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.currentCustomerInfo;
});

// Provider for subscription status
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

// Provider for checking active subscription
final hasActiveSubscriptionProvider = Provider.family<bool, String?>((ref, entitlementId) {
  final service = ref.read(revenueCatServiceProvider);
  return service.hasActiveSubscription(entitlementId);
});

// Provider for current offerings
final currentOfferingsProvider = Provider<purchases.Offerings?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.currentOfferings;
});

// Provider for available products
final availableProductsProvider = Provider<List<purchases.StoreProduct>>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.getAvailableProducts();
});

// Provider for available packages
final availablePackagesProvider = Provider<List<purchases.Package>>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.getAvailablePackages();
});

// Provider for premium features check
final isPremiumUserProvider = Provider<bool>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.hasActiveSubscription();
});

// AsyncNotifier for managing subscription state
class SubscriptionNotifier extends AsyncNotifier<SubscriptionState> {
  late revenue_cat.RevenueCatService _revenueCatService;

  @override
  Future<SubscriptionState> build() async {
    _revenueCatService = ref.read(revenueCatServiceProvider);
    return _loadInitialState();
  }

  Future<SubscriptionState> _loadInitialState() async {
    final customerInfo = _revenueCatService.currentCustomerInfo;
    final offerings = _revenueCatService.currentOfferings;
    
    return SubscriptionState(
      customerInfo: customerInfo,
      offerings: offerings,
    );
  }

  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    try {
      await _revenueCatService.refreshCustomerInfo();
      await _revenueCatService.refreshOfferings();
      
      final customerInfo = _revenueCatService.currentCustomerInfo;
      final offerings = _revenueCatService.currentOfferings;
      
      state = AsyncValue.data(SubscriptionState(
        customerInfo: customerInfo,
        offerings: offerings,
      ));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<bool> purchasePackage(purchases.Package package) async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));
      
      await _revenueCatService.purchasePackage(package);
      
      // Refresh data after successful purchase
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData((current) => current.copyWith(
        isLoading: false,
        error: error.toString(),
      ));
      return false;
    }
  }

  Future<bool> purchaseProduct(purchases.StoreProduct product) async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));
      
      await _revenueCatService.purchaseProduct(product);
      
      // Refresh data after successful purchase
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData((current) => current.copyWith(
        isLoading: false,
        error: error.toString(),
      ));
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    try {
      state = state.whenData((current) => current.copyWith(isLoading: true));
      
      await _revenueCatService.restorePurchases();
      
      // Refresh data after restore
      await refreshData();
      return true;
    } catch (error) {
      state = state.whenData((current) => current.copyWith(
        isLoading: false,
        error: error.toString(),
      ));
      return false;
    }
  }

  void clearError() {
    state = state.whenData((current) => current.copyWith());
  }
}

// Provider for subscription state notifier
final subscriptionNotifierProvider = AsyncNotifierProvider<SubscriptionNotifier, SubscriptionState>(() {
  return SubscriptionNotifier();
});

// Data class for subscription state
class SubscriptionState {

  const SubscriptionState({
    this.customerInfo,
    this.offerings,
    this.isLoading = false,
    this.error,
  });
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

  List<purchases.Package> get availablePackages {
    return offerings?.current?.availablePackages ?? [];
  }

  List<purchases.StoreProduct> get availableProducts {
    return availablePackages.map((package) => package.storeProduct).toList();
  }
}