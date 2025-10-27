import 'package:waffir/features/subscription/domain/entities/subscription_type.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_duration.dart';

class Subscription {

  const Subscription({
    required this.id,
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.priceString,
    required this.type,
    required this.duration,
    required this.isActive,
    this.expiresAt,
    this.purchasedAt,
    required this.willRenew,
    required this.isInGracePeriod,
    required this.isInBillingRetry,
  });
  final String id;
  final String productId;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final String priceString;
  final SubscriptionType type;
  final SubscriptionDuration duration;
  final bool isActive;
  final DateTime? expiresAt;
  final DateTime? purchasedAt;
  final bool willRenew;
  final bool isInGracePeriod;
  final bool isInBillingRetry;
}