import 'package:waffir/features/subscription/domain/entities/subscription_product.dart';

class SubscriptionOffering {

  const SubscriptionOffering({
    required this.id,
    required this.title,
    required this.description,
    required this.isDefault,
    required this.products,
  });
  final String id;
  final String title;
  final String description;
  final bool isDefault;
  final List<SubscriptionProduct> products;
}