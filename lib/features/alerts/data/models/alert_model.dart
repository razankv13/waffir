import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:waffir/features/deals/domain/entities/alert.dart';

part 'alert_model.freezed.dart';
part 'alert_model.g.dart';

/// Data model for alert with JSON serialization
///
/// Maps between Supabase database schema and domain Alert entity.
@freezed
abstract class AlertModel with _$AlertModel {
  const factory AlertModel({
    required String id,
    required String keyword,
    @Default(false) bool isSubscribed,
    int? subscriberCount,
    DateTime? createdAt,
  }) = _AlertModel;

  const AlertModel._();

  factory AlertModel.fromJson(Map<String, dynamic> json) => _$AlertModelFromJson(json);

  /// Convert model to domain entity
  Alert toDomain() => Alert(
        id: id,
        keyword: keyword,
        isSubscribed: isSubscribed,
        subscriberCount: subscriberCount,
        createdAt: createdAt,
      );
}
