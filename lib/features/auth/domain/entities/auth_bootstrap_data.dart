import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bootstrap_data.freezed.dart';

@freezed
abstract class AuthBootstrapData with _$AuthBootstrapData {
  const factory AuthBootstrapData({
    required String userId,
    required Map<String, dynamic>? accountSummary,
    required Map<String, dynamic>? userSettings,
    required bool? hasHadSubscriptionBefore,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> familyInvites,
    required DateTime fetchedAt,
  }) = _AuthBootstrapData;
}
