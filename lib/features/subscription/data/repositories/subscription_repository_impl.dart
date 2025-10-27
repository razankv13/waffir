import 'package:waffir/core/services/revenue_cat_service.dart' as revenue_cat_service;
import 'package:purchases_flutter/purchases_flutter.dart' as purchases_flutter;
import 'package:waffir/features/subscription/domain/entities/subscription.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_offering.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_product.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_type.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_duration.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_status.dart';
import 'package:waffir/features/subscription/domain/entities/purchase_result.dart';
import 'package:waffir/features/subscription/domain/entities/purchase.dart';
import 'package:waffir/features/subscription/domain/entities/purchase_state.dart';
import 'package:waffir/features/subscription/domain/entities/customer_info.dart';
import 'package:waffir/features/subscription/domain/entities/entitlement_info.dart';
import 'package:waffir/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:waffir/core/utils/logger.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {

  SubscriptionRepositoryImpl(this._revenueCatService);
  final revenue_cat_service.RevenueCatService _revenueCatService;

  @override
  Future<void> initialize({
    required String apiKey,
    String? userId,
    bool enableDebugLogs = false,
  }) async {
    await _revenueCatService.initialize(
      apiKey: apiKey,
      userId: userId,
      enableDebugLogs: enableDebugLogs,
    );
  }

  @override
  Future<CustomerInfo> getCustomerInfo() async {
    final customerInfo = await purchases_flutter.Purchases.getCustomerInfo();
    return _mapCustomerInfo(customerInfo);
  }

  @override
  Future<CustomerInfo> refreshCustomerInfo() async {
    await _revenueCatService.refreshCustomerInfo();
    final customerInfo = _revenueCatService.currentCustomerInfo;
    if (customerInfo == null) {
      throw Exception('Failed to refresh customer info');
    }
    return _mapCustomerInfo(customerInfo);
  }

  @override
  Future<List<SubscriptionOffering>> getOfferings() async {
    await _revenueCatService.refreshOfferings();
    final offerings = _revenueCatService.currentOfferings;
    
    if (offerings == null || offerings.all.isEmpty) {
      return [];
    }

    return offerings.all.values.map((offering) {
      return SubscriptionOffering(
        id: offering.identifier,
        title: offering.serverDescription,
        description: offering.serverDescription,
        isDefault: offering.identifier == offerings.current?.identifier,
        products: offering.availablePackages.map((package) {
          final product = package.storeProduct;
          return SubscriptionProduct(
            id: product.identifier,
            title: product.title,
            description: product.description,
            price: product.price,
            currencyCode: product.currencyCode,
            priceString: product.priceString,
            type: _mapPackageTypeToSubscriptionType(package.packageType),
            duration: _mapPackageTypeToDuration(package.packageType),
            introductoryPrice: product.introductoryPrice?.priceString,
            introductoryPricePeriod: product.introductoryPrice?.periodUnit.toString(),
            introductoryPriceCycles: product.introductoryPrice?.periodNumberOfUnits,
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Future<void> refreshOfferings() async {
    await _revenueCatService.refreshOfferings();
  }

  @override
  Future<PurchaseResult> purchaseProduct(String productId) async {
    try {
      final offerings = _revenueCatService.currentOfferings;
      if (offerings == null) {
        throw Exception('No offerings available');
      }

      // Find the product in available packages
      purchases_flutter.Package? targetPackage;
      for (final offering in offerings.all.values) {
        for (final package in offering.availablePackages) {
          if (package.storeProduct.identifier == productId) {
            targetPackage = package;
            break;
          }
        }
        if (targetPackage != null) break;
      }

      if (targetPackage == null) {
        throw Exception('Product not found: $productId');
      }

      final customerInfo = await _revenueCatService.purchasePackage(targetPackage);
      
      return PurchaseResult(
        purchase: Purchase(
          id: productId,
          productId: productId,
          transactionId: '', // RevenueCat doesn't expose transaction ID directly
          purchaseDate: DateTime.now(),
          state: PurchaseState.purchased,
          isAcknowledged: true,
          isAutoRenewing: true,
          price: targetPackage.storeProduct.price,
          currencyCode: targetPackage.storeProduct.currencyCode,
        ),
        isNewPurchase: true,
        customerInfo: _mapCustomerInfo(customerInfo),
      );
    } catch (e) {
      AppLogger.error('Failed to purchase product $productId: $e');
      rethrow;
    }
  }

  @override
  Future<PurchaseResult> purchasePackage(String packageId) async {
    try {
      final offerings = _revenueCatService.currentOfferings;
      if (offerings == null) {
        throw Exception('No offerings available');
      }

      purchases_flutter.Package? targetPackage;
      for (final offering in offerings.all.values) {
        targetPackage = offering.availablePackages
            .cast<purchases_flutter.Package?>()
            .firstWhere(
              (package) => package!.identifier == packageId,
              orElse: () => null,
            );
        if (targetPackage != null) break;
      }

      if (targetPackage == null) {
        throw Exception('Package not found: $packageId');
      }

      final customerInfo = await _revenueCatService.purchasePackage(targetPackage);

      return PurchaseResult(
        purchase: Purchase(
          id: packageId,
          productId: targetPackage.storeProduct.identifier,
          transactionId: '', // RevenueCat doesn't expose transaction ID directly
          purchaseDate: DateTime.now(),
          state: PurchaseState.purchased,
          isAcknowledged: true,
          isAutoRenewing: true,
          price: targetPackage.storeProduct.price,
          currencyCode: targetPackage.storeProduct.currencyCode,
        ),
        isNewPurchase: true,
        customerInfo: _mapCustomerInfo(customerInfo),
      );
    } catch (e) {
      AppLogger.error('Failed to purchase package $packageId: $e');
      rethrow;
    }
  }

  @override
  Future<CustomerInfo> restorePurchases() async {
    final customerInfo = await _revenueCatService.restorePurchases();
    return _mapCustomerInfo(customerInfo);
  }

  @override
  bool hasActiveSubscription([String? entitlementId]) {
    return _revenueCatService.hasActiveSubscription(entitlementId);
  }

  @override
  bool hasPurchased(String productId) {
    return _revenueCatService.hasPurchased(productId);
  }

  @override
  SubscriptionStatus getSubscriptionStatus([String? entitlementId]) {
    final status = _revenueCatService.getSubscriptionStatus(entitlementId);
    switch (status) {
      case revenue_cat_service.SubscriptionStatus.unknown:
        return SubscriptionStatus.unknown;
      case revenue_cat_service.SubscriptionStatus.notSubscribed:
        return SubscriptionStatus.notSubscribed;
      case revenue_cat_service.SubscriptionStatus.subscribed:
        return SubscriptionStatus.subscribed;
      case revenue_cat_service.SubscriptionStatus.expired:
        return SubscriptionStatus.expired;
      case revenue_cat_service.SubscriptionStatus.inGracePeriod:
        return SubscriptionStatus.inGracePeriod;
      case revenue_cat_service.SubscriptionStatus.inBillingRetry:
        return SubscriptionStatus.inBillingRetry;
    }
  }

  @override
  Subscription? getActiveSubscription([String? entitlementId]) {
    final customerInfo = _revenueCatService.currentCustomerInfo;
    if (customerInfo == null) return null;

    final entitlements = customerInfo.entitlements;
    purchases_flutter.EntitlementInfo? targetEntitlement;

    if (entitlementId != null) {
      targetEntitlement = entitlements.active[entitlementId];
    } else if (entitlements.active.isNotEmpty) {
      targetEntitlement = entitlements.active.values.first;
    }

    if (targetEntitlement == null) return null;

    return Subscription(
      id: targetEntitlement.identifier,
      productId: targetEntitlement.productIdentifier,
      title: targetEntitlement.productIdentifier, // RevenueCat doesn't provide title
      description: '', // RevenueCat doesn't provide description
      price: 0.0, // RevenueCat doesn't provide price in entitlement
      currencyCode: 'USD', // Default, RevenueCat doesn't provide this in entitlement
      priceString: '', // RevenueCat doesn't provide this in entitlement
      type: SubscriptionType.monthly, // Default, can't determine from RevenueCat
      duration: SubscriptionDuration.month, // Default, can't determine from RevenueCat
      isActive: targetEntitlement.isActive,
      expiresAt: targetEntitlement.expirationDate != null ? DateTime.parse(targetEntitlement.expirationDate!) : null,
      purchasedAt: DateTime.parse(targetEntitlement.latestPurchaseDate),
      willRenew: targetEntitlement.willRenew,
      isInGracePeriod: targetEntitlement.isActive && (targetEntitlement.expirationDate != null ? DateTime.parse(targetEntitlement.expirationDate!).isBefore(DateTime.now()) : false),
      isInBillingRetry: !targetEntitlement.isActive && targetEntitlement.willRenew,
    );
  }

  @override
  Future<CustomerInfo> loginUser(String userId) async {
    final loginResult = await purchases_flutter.Purchases.logIn(userId);
    return _mapCustomerInfo(loginResult.customerInfo);
  }

  @override
  Future<CustomerInfo> logoutUser() async {
    final customerInfo = await _revenueCatService.logOut();
    return _mapCustomerInfo(customerInfo);
  }

  @override
  Future<void> setUserAttributes(Map<String, String> attributes) async {
    await _revenueCatService.setAttributes(attributes);
  }

  @override
  Future<void> setUserEmail(String email) async {
    await _revenueCatService.setEmail(email);
  }

  @override
  Future<void> setUserPhoneNumber(String phoneNumber) async {
    await _revenueCatService.setPhoneNumber(phoneNumber);
  }

  @override
  Future<void> setUserDisplayName(String displayName) async {
    await _revenueCatService.setDisplayName(displayName);
  }

  @override
  Stream<CustomerInfo> get customerInfoStream {
    return _revenueCatService.customerInfoStream.map(_mapCustomerInfo);
  }

  @override
  bool get isInitialized => _revenueCatService.isInitialized;

  @override
  CustomerInfo? get currentCustomerInfo {
    final customerInfo = _revenueCatService.currentCustomerInfo;
    return customerInfo != null ? _mapCustomerInfo(customerInfo) : null;
  }

  @override
  List<SubscriptionOffering>? get currentOfferings {
    final offerings = _revenueCatService.currentOfferings;
    if (offerings == null || offerings.all.isEmpty) return null;

    return offerings.all.values.map((offering) {
      return SubscriptionOffering(
        id: offering.identifier,
        title: offering.serverDescription,
        description: offering.serverDescription,
        isDefault: offering.identifier == offerings.current?.identifier,
        products: offering.availablePackages.map((package) {
          final product = package.storeProduct;
          return SubscriptionProduct(
            id: product.identifier,
            title: product.title,
            description: product.description,
            price: product.price,
            currencyCode: product.currencyCode,
            priceString: product.priceString,
            type: _mapPackageTypeToSubscriptionType(package.packageType),
            duration: _mapPackageTypeToDuration(package.packageType),
            introductoryPrice: product.introductoryPrice?.priceString,
            introductoryPricePeriod: product.introductoryPrice?.periodUnit.toString(),
            introductoryPriceCycles: product.introductoryPrice?.periodNumberOfUnits,
          );
        }).toList(),
      );
    }).toList();
  }

  CustomerInfo _mapCustomerInfo(PurchasesCustomerInfo customerInfo) {
    return CustomerInfo(
      userId: customerInfo.originalAppUserId,
      activeSubscriptions: customerInfo.entitlements.active.keys.toList(),
      allPurchasedProductIds: customerInfo.allPurchasedProductIdentifiers.toList(),
      requestDate: customerInfo.requestDate,
      firstSeen: customerInfo.firstSeen,
      originalAppUserId: customerInfo.originalAppUserId,
      entitlements: customerInfo.entitlements.all.map(
        (key, entitlement) => MapEntry(
          key,
          EntitlementInfo(
            identifier: entitlement.identifier,
            isActive: entitlement.isActive,
            willRenew: entitlement.willRenew,
            periodType: entitlement.periodType.name,
            latestPurchaseDate: entitlement.latestPurchaseDate,
            productIdentifier: entitlement.productIdentifier,
            isSandbox: entitlement.isSandbox,
            originalPurchaseDate: entitlement.originalPurchaseDate,
            expirationDate: entitlement.expirationDate != null ? DateTime.parse(entitlement.expirationDate!) : null,
            unsubscribeDetectedAt: entitlement.unsubscribeDetectedAt,
            billingIssueDetectedAt: entitlement.billingIssueDetectedAt,
          ),
        ),
      ),
    );
  }

  SubscriptionType _mapPackageTypeToSubscriptionType(purchases_flutter.PackageType packageType) {
    switch (packageType) {
      case purchases_flutter.PackageType.weekly:
        return SubscriptionType.weekly;
      case purchases_flutter.PackageType.monthly:
        return SubscriptionType.monthly;
      case purchases_flutter.PackageType.threeMonth:
        return SubscriptionType.quarterly;
      case purchases_flutter.PackageType.sixMonth:
        return SubscriptionType.quarterly;
      case purchases_flutter.PackageType.annual:
        return SubscriptionType.yearly;
      case purchases_flutter.PackageType.lifetime:
        return SubscriptionType.lifetime;
      default:
        return SubscriptionType.monthly;
    }
  }

  SubscriptionDuration _mapPackageTypeToDuration(purchases_flutter.PackageType packageType) {
    switch (packageType) {
      case purchases_flutter.PackageType.weekly:
        return SubscriptionDuration.week;
      case purchases_flutter.PackageType.monthly:
        return SubscriptionDuration.month;
      case purchases_flutter.PackageType.threeMonth:
        return SubscriptionDuration.quarter;
      case purchases_flutter.PackageType.sixMonth:
        return SubscriptionDuration.quarter;
      case purchases_flutter.PackageType.annual:
        return SubscriptionDuration.year;
      case purchases_flutter.PackageType.lifetime:
        return SubscriptionDuration.lifetime;
      default:
        return SubscriptionDuration.month;
    }
  }
}

// Type alias to avoid conflicts
typedef PurchasesCustomerInfo = purchases_flutter.CustomerInfo;