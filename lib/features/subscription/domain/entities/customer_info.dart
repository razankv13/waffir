import 'package:waffir/features/subscription/domain/entities/entitlement_info.dart';

class CustomerInfo {

  const CustomerInfo({
    required this.userId,
    required this.activeSubscriptions,
    required this.allPurchasedProductIds,
    required this.requestDate,
    required this.firstSeen,
    required this.originalAppUserId,
    required this.entitlements,
  });
  final String userId;
  final List<String> activeSubscriptions;
  final List<String> allPurchasedProductIds;
  final String requestDate;
  final String firstSeen;
  final String originalAppUserId;
  final Map<String, EntitlementInfo> entitlements;
}