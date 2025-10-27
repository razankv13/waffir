import 'package:waffir/features/subscription/domain/entities/subscription_type.dart';
import 'package:waffir/features/subscription/domain/entities/subscription_duration.dart';

class SubscriptionProduct {

  const SubscriptionProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.priceString,
    required this.type,
    required this.duration,
    this.introductoryPrice,
    this.introductoryPricePeriod,
    this.introductoryPriceCycles,
  });
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final String priceString;
  final SubscriptionType type;
  final SubscriptionDuration duration;
  final String? introductoryPrice;
  final String? introductoryPricePeriod;
  final int? introductoryPriceCycles;
}