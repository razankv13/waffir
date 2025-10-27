import 'dart:async';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/utils/logger.dart';

enum SubscriptionStatus {
  unknown,
  notSubscribed,
  subscribed,
  expired,
  inGracePeriod,
  inBillingRetry,
}

class RevenueCatService {

  RevenueCatService._();
  static RevenueCatService? _instance;
  static RevenueCatService get instance => _instance ??= RevenueCatService._();

  bool _isInitialized = false;
  CustomerInfo? _currentCustomerInfo;
  Offerings? _currentOfferings;

  final StreamController<CustomerInfo> _customerInfoController =
      StreamController<CustomerInfo>.broadcast();
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  bool get isInitialized => _isInitialized;
  CustomerInfo? get currentCustomerInfo => _currentCustomerInfo;
  Offerings? get currentOfferings => _currentOfferings;

  Future<void> initialize({
    required String apiKey,
    String? userId,
    bool enableDebugLogs = false,
  }) async {
    if (_isInitialized) return;

    try {
      if (enableDebugLogs) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      PurchasesConfiguration configuration;
      if (userId != null) {
        configuration = PurchasesConfiguration(apiKey)..appUserID = userId;
      } else {
        configuration = PurchasesConfiguration(apiKey);
      }

      await Purchases.configure(configuration);

      // Set up listener for customer info updates
      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _currentCustomerInfo = customerInfo;
        _customerInfoController.add(customerInfo);
      });

      // Get initial customer info
      _currentCustomerInfo = await Purchases.getCustomerInfo();
      
      // Load offerings
      await _loadOfferings();

      _isInitialized = true;
      AppLogger.info('RevenueCat initialized successfully');
      
      if (_currentCustomerInfo != null) {
        _customerInfoController.add(_currentCustomerInfo!);
      }
    } catch (e) {
      AppLogger.error('Failed to initialize RevenueCat: $e');
      rethrow;
    }
  }

  Future<void> _loadOfferings() async {
    try {
      _currentOfferings = await Purchases.getOfferings();
      AppLogger.info('Loaded ${_currentOfferings?.all.length ?? 0} offerings');
    } catch (e) {
      AppLogger.error('Failed to load offerings: $e');
    }
  }

  Future<void> refreshOfferings() async {
    await _loadOfferings();
  }

  Future<void> refreshCustomerInfo() async {
    try {
      _currentCustomerInfo = await Purchases.getCustomerInfo();
      if (_currentCustomerInfo != null) {
        _customerInfoController.add(_currentCustomerInfo!);
      }
    } catch (e) {
      AppLogger.error('Failed to refresh customer info: $e');
    }
  }

  Future<CustomerInfo> purchaseProduct(StoreProduct product) async {
    try {
      final purchaserInfo = await Purchases.purchaseStoreProduct(product);
      _currentCustomerInfo = purchaserInfo.customerInfo;
      _customerInfoController.add(_currentCustomerInfo!);
      
      AppLogger.info('Successfully purchased: ${product.identifier}');
      return _currentCustomerInfo!;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        AppLogger.info('Purchase cancelled by user');
        throw const PurchaseCancelledException();
      } else {
        AppLogger.error('Purchase failed: ${e.message}');
        throw PurchaseFailedException(e.message ?? 'Unknown error');
      }
    } catch (e) {
      AppLogger.error('Unexpected purchase error: $e');
      throw const PurchaseFailedException('Unexpected error occurred');
    }
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      _currentCustomerInfo = purchaserInfo.customerInfo;
      _customerInfoController.add(_currentCustomerInfo!);
      
      AppLogger.info('Successfully purchased package: ${package.identifier}');
      return _currentCustomerInfo!;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        AppLogger.info('Purchase cancelled by user');
        throw const PurchaseCancelledException();
      } else {
        AppLogger.error('Purchase failed: ${e.message}');
        throw PurchaseFailedException(e.message ?? 'Unknown error');
      }
    } catch (e) {
      AppLogger.error('Unexpected purchase error: $e');
      throw const PurchaseFailedException('Unexpected error occurred');
    }
  }

  Future<CustomerInfo> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _currentCustomerInfo = customerInfo;
      _customerInfoController.add(_currentCustomerInfo!);
      
      AppLogger.info('Successfully restored purchases');
      return customerInfo;
    } catch (e) {
      AppLogger.error('Failed to restore purchases: $e');
      throw const RestoreFailedException('Failed to restore purchases');
    }
  }

  Future<void> logIn(String userId) async {
    try {
      final loginResult = await Purchases.logIn(userId);
      _currentCustomerInfo = loginResult.customerInfo;
      _customerInfoController.add(_currentCustomerInfo!);
      
      AppLogger.info('Successfully logged in user: $userId');
    } catch (e) {
      AppLogger.error('Failed to log in user: $e');
      rethrow;
    }
  }

  Future<CustomerInfo> logOut() async {
    try {
      final customerInfo = await Purchases.logOut();
      _currentCustomerInfo = customerInfo;
      _customerInfoController.add(_currentCustomerInfo!);
      
      AppLogger.info('Successfully logged out user');
      return customerInfo;
    } catch (e) {
      AppLogger.error('Failed to log out user: $e');
      rethrow;
    }
  }

  bool hasActiveSubscription([String? entitlementId]) {
    if (_currentCustomerInfo == null) return false;
    
    if (entitlementId != null) {
      return _currentCustomerInfo!.entitlements.active.containsKey(entitlementId);
    }
    
    return _currentCustomerInfo!.entitlements.active.isNotEmpty;
  }

  bool hasPurchased(String productId) {
    if (_currentCustomerInfo == null) return false;
    
    return _currentCustomerInfo!.allPurchasedProductIdentifiers.contains(productId);
  }

  SubscriptionStatus getSubscriptionStatus([String? entitlementId]) {
    if (_currentCustomerInfo == null) return SubscriptionStatus.unknown;

    final entitlements = _currentCustomerInfo!.entitlements;
    
    if (entitlementId != null) {
      final entitlement = entitlements.all[entitlementId];
      if (entitlement == null) return SubscriptionStatus.notSubscribed;
      
      if (entitlement.isActive) return SubscriptionStatus.subscribed;
      if (entitlement.willRenew) return SubscriptionStatus.inBillingRetry;
      
      return SubscriptionStatus.expired;
    }
    
    if (entitlements.active.isNotEmpty) return SubscriptionStatus.subscribed;
    
    // Check if any entitlement is in billing retry
    for (final entitlement in entitlements.all.values) {
      if (entitlement.willRenew && !entitlement.isActive) {
        return SubscriptionStatus.inBillingRetry;
      }
    }
    
    return SubscriptionStatus.notSubscribed;
  }

  List<StoreProduct> getAvailableProducts() {
    if (_currentOfferings?.current?.availablePackages.isEmpty ?? true) {
      return [];
    }
    
    return _currentOfferings!.current!.availablePackages
        .map((package) => package.storeProduct)
        .toList();
  }

  List<Package> getAvailablePackages() {
    return _currentOfferings?.current?.availablePackages ?? [];
  }

  Package? getPackage(PackageType packageType) {
    final packages = _currentOfferings?.current?.availablePackages;
    if (packages == null) return null;
    
    try {
      return packages.firstWhere((package) => package.packageType == packageType);
    } catch (e) {
      return null;
    }
  }

  Future<void> setAttributes(Map<String, String> attributes) async {
    try {
      await Purchases.setAttributes(attributes);
      AppLogger.info('Successfully set user attributes');
    } catch (e) {
      AppLogger.error('Failed to set attributes: $e');
    }
  }

  Future<void> setEmail(String email) async {
    try {
      await Purchases.setEmail(email);
      AppLogger.info('Successfully set user email');
    } catch (e) {
      AppLogger.error('Failed to set email: $e');
    }
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    try {
      await Purchases.setPhoneNumber(phoneNumber);
      AppLogger.info('Successfully set user phone number');
    } catch (e) {
      AppLogger.error('Failed to set phone number: $e');
    }
  }

  Future<void> setDisplayName(String displayName) async {
    try {
      await Purchases.setDisplayName(displayName);
      AppLogger.info('Successfully set user display name');
    } catch (e) {
      AppLogger.error('Failed to set display name: $e');
    }
  }

  void dispose() {
    _customerInfoController.close();
  }
}

// Provider for RevenueCat service
final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService.instance;
});

// Provider for customer info stream
final customerInfoStreamProvider = StreamProvider<CustomerInfo?>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.customerInfoStream;
});

// Provider for subscription status
final subscriptionStatusProvider = Provider<SubscriptionStatus>((ref) {
  final service = ref.read(revenueCatServiceProvider);
  return service.getSubscriptionStatus();
});

// Provider for active subscription check
final hasActiveSubscriptionProvider = Provider.family<bool, String?>((ref, entitlementId) {
  final service = ref.read(revenueCatServiceProvider);
  return service.hasActiveSubscription(entitlementId);
});

// Custom exceptions
class PurchaseCancelledException implements Exception {
  const PurchaseCancelledException();
  
  @override
  String toString() => 'Purchase was cancelled by the user';
}

class PurchaseFailedException implements Exception {
  
  const PurchaseFailedException(this.message);
  final String message;
  
  @override
  String toString() => 'Purchase failed: $message';
}

class RestoreFailedException implements Exception {
  
  const RestoreFailedException(this.message);
  final String message;
  
  @override
  String toString() => 'Restore failed: $message';
}