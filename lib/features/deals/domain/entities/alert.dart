import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';

/// Domain entity for a deal alert
@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String title,
    required String description,
    required AlertType type,
    String? iconUrl,
    String? category,
    bool? isSubscribed,
    int? subscriberCount,
    DateTime? createdAt,
  }) = _Alert;

  const Alert._();

  /// Check if alert is popular
  bool get isPopular => subscriberCount != null && subscriberCount! > 100;
}

/// Alert type enum
enum AlertType {
  deal,
  priceDrop,
  newProduct,
  categoryAlert,
  storeAlert,
  custom;

  String get displayName {
    switch (this) {
      case AlertType.deal:
        return 'Deal Alert';
      case AlertType.priceDrop:
        return 'Price Drop';
      case AlertType.newProduct:
        return 'New Product';
      case AlertType.categoryAlert:
        return 'Category Alert';
      case AlertType.storeAlert:
        return 'Store Alert';
      case AlertType.custom:
        return 'Custom Alert';
    }
  }
}
