import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert.freezed.dart';
part 'alert.g.dart';

/// Domain entity for a deal alert
///
/// Represents a keyword-based alert that notifies users when deals
/// matching their interests are available.
@freezed
abstract class Alert with _$Alert {
  const factory Alert({
    required String id,
    required String keyword,
    @Default(false) bool isSubscribed,
    int? subscriberCount,
    DateTime? createdAt,
  }) = _Alert;

  const Alert._();

  factory Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

  /// Check if alert is popular (>100 subscribers)
  bool get isPopular => subscriberCount != null && subscriberCount! > 100;
}
