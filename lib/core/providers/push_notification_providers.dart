import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waffir/core/services/push_notification_service.dart';

/// Provider for PushNotificationService singleton
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService.instance;
});

/// Future provider to check current notification permission status
final pushNotificationPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(pushNotificationServiceProvider);
  return await service.hasPermission();
});
