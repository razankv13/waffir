import 'package:waffir/features/subscription/domain/entities/customer_info.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_offering.dart';
import 'package:waffir/features/subscription/domain/entities/purchase_result.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_status.dart';
import 'package:waffir/features/subscription/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  /// Initialize the subscription service
  Future<void> initialize({required String apiKey, String? userId, bool enableDebugLogs = false});

  /// Get current customer information
  Future<CustomerInfo> getCustomerInfo();

  /// Refresh customer information from the server
  Future<CustomerInfo> refreshCustomerInfo();

  /// Get available subscription offerings
  Future<List<SubscriptionOffering>> getOfferings();

  /// Refresh offerings from the server
  Future<void> refreshOfferings();

  /// Purchase a subscription product
  Future<PurchaseResult> purchaseProduct(String productId);

  /// Purchase a subscription package
  Future<PurchaseResult> purchasePackage(String packageId);

  /// Restore previous purchases
  Future<CustomerInfo> restorePurchases();

  /// Check if user has an active subscription
  bool hasActiveSubscription([String? entitlementId]);

  /// Check if user has purchased a specific product
  bool hasPurchased(String productId);

  /// Get current subscription status
  SubscriptionStatus getSubscriptionStatus([String? entitlementId]);

  /// Get active subscription
  Subscription? getActiveSubscription([String? entitlementId]);

  /// Login user with a specific user ID
  Future<CustomerInfo> loginUser(String userId);

  /// Logout current user
  Future<CustomerInfo> logoutUser();

  /// Set user attributes for analytics and segmentation
  Future<void> setUserAttributes(Map<String, String> attributes);

  /// Set user email
  Future<void> setUserEmail(String email);

  /// Set user phone number
  Future<void> setUserPhoneNumber(String phoneNumber);

  /// Set user display name
  Future<void> setUserDisplayName(String displayName);

  /// Listen to customer info updates
  Stream<CustomerInfo> get customerInfoStream;

  /// Check if the service is initialized
  bool get isInitialized;

  /// Get current customer info without making a network request
  CustomerInfo? get currentCustomerInfo;

  /// Get current offerings without making a network request
  List<SubscriptionOffering>? get currentOfferings;
}
