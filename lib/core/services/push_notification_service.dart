import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/core/navigation/notification_router.dart';

/// Top-level background message handler (required by Firebase)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.info('🔔 Background message: ${message.messageId}');
}

class PushNotificationService {
  PushNotificationService._internal();
  static PushNotificationService? _instance;
  static PushNotificationService get instance => _instance ??= PushNotificationService._internal();

  FirebaseMessaging? _messaging;
  SupabaseClient? _supabase;
  String? _deviceToken;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  String? get deviceToken => _deviceToken;

  /// Initialize push notification service
  Future<void> initialize({required SupabaseClient supabase}) async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔔 Initializing push notifications...');

      _supabase = supabase;
      _messaging = FirebaseMessaging.instance;

      // Request permissions (iOS + Android 13+)
      final settings = await requestPermissions();

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        AppLogger.warning('⚠️ Push notification permissions not granted');
        return;
      }

      // Get FCM token
      _deviceToken = await _messaging!.getToken();
      AppLogger.info('🔔 FCM Token: $_deviceToken');

      // Register with Supabase
      if (_deviceToken != null) {
        await _registerDeviceToken(_deviceToken!);
      }

      // Listen for token refresh
      _messaging!.onTokenRefresh.listen(_registerDeviceToken);

      // Set up message handlers
      _setupMessageHandlers();

      // Set up background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      _isInitialized = true;
      AppLogger.info('✅ Push notifications initialized');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to initialize push', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> requestPermissions() async {
    if (_messaging == null) {
        _messaging = FirebaseMessaging.instance;
    }
    return await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Register device token with Supabase
  Future<void> _registerDeviceToken(String token) async {
    try {
      final userId = _supabase!.auth.currentUser?.id;
      if (userId == null) {
        AppLogger.warning('⚠️ User not authenticated, skipping token registration');
        return;
      }

      final platform = defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

      await _supabase!.rpc('upsert_device_token', params: {
        'p_token': token,
        'p_device_type': platform,
      });

      _deviceToken = token;
      AppLogger.info('✅ Device token registered with Supabase');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to register device token', error: e, stackTrace: stackTrace);
    }
  }

  /// Set up message handlers
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.info('🔔 Foreground message: ${message.messageId}');
      _handleMessage(message, isForeground: true);
    });

    // Background messages (app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info('🔔 Message opened app: ${message.messageId}');
      _handleMessage(message, isForeground: false);
    });

    // Initial message (app opened from terminated state)
    _messaging!.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        AppLogger.info('🔔 Initial message: ${message.messageId}');
        _handleMessage(message, isForeground: false);
      }
    });
  }

  /// Handle incoming message
  void _handleMessage(RemoteMessage message, {required bool isForeground}) {
    final data = message.data;
    final type = data['type'] as String?;
    final dealId = data['deal_id'] as String?;

    if (type == null || dealId == null) {
      AppLogger.warning('⚠️ Invalid notification payload');
      return;
    }

    // Route to appropriate screen (implement in NotificationRouter)
    NotificationRouter.handleNotification(data);
  }

  /// Check permission status
  Future<bool> hasPermission() async {
    if (_messaging == null) return false;
    final settings = await _messaging!.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}
