import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:waffir/firebase_options.dart';
import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';

class FirebaseService {
  FirebaseService._internal();
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._internal();

  // Firebase instances
  FirebaseAnalytics? _analytics;
  FirebasePerformance? _performance;
  FirebaseRemoteConfig? _remoteConfig;
  FirebaseCrashlytics? _crashlytics;
  FirebaseMessaging? _messaging;

  // Getters
  FirebaseAnalytics? get analytics => _analytics;
  FirebasePerformance? get performance => _performance;
  FirebaseRemoteConfig? get remoteConfig => _remoteConfig;
  FirebaseCrashlytics? get crashlytics => _crashlytics;
  FirebaseMessaging? get messaging => _messaging;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize Firebase with all services
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.info('🔥 Firebase already initialized');
      return;
    }

    try {
      AppLogger.info('🔥 Initializing Firebase...');

      // Initialize Firebase Core
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      // Initialize services based on environment
        await _initializeAnalytics();
        await _initializePerformance();
        await _initializeCrashlytics();
        await _initializeMessaging();
        await _initializeRemoteConfig();

      _isInitialized = true;
      AppLogger.info('✅ Firebase initialization completed');
    } catch (error, stackTrace) {
      AppLogger.error('❌ Firebase initialization failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Initialize Firebase Analytics
  Future<void> _initializeAnalytics() async {
    try {
      _analytics = FirebaseAnalytics.instance;

      // Set analytics collection based on environment
      await _analytics!.setAnalyticsCollectionEnabled(AppConstants.enableAnalytics);

      // Set default parameters
      await _analytics!.setUserProperty(name: 'app_version', value: AppConstants.appVersion);
      await _analytics!.setUserProperty(name: 'build_number', value: AppConstants.buildNumber);
      await _analytics!.setUserProperty(name: 'environment', value: AppConstants.environment);

      AppLogger.info('✅ Firebase Analytics initialized');
    } catch (error, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Firebase Analytics',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize Firebase Performance
  Future<void> _initializePerformance() async {
    try {
      _performance = FirebasePerformance.instance;

      // Enable/disable based on environment
      await _performance!.setPerformanceCollectionEnabled(AppConstants.enablePerformanceMonitoring);

      AppLogger.info('✅ Firebase Performance initialized');
    } catch (error, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Firebase Performance',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize Firebase Crashlytics
  Future<void> _initializeCrashlytics() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;

      // Set up crash reporting based on environment
      await _crashlytics!.setCrashlyticsCollectionEnabled(AppConstants.enableCrashReporting);

      // Set user identifier
      await _crashlytics!.setUserIdentifier('anonymous_user');

      // Set custom keys
      await _crashlytics!.setCustomKey('environment', AppConstants.environment);
      await _crashlytics!.setCustomKey('app_version', AppConstants.appVersion);

      // Handle Flutter errors
      FlutterError.onError = (errorDetails) {
        _crashlytics!.recordFlutterFatalError(errorDetails);
      };

      // Handle platform errors
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics!.recordError(error, stack, fatal: true);
        return true;
      };

      AppLogger.info('✅ Firebase Crashlytics initialized');
    } catch (error, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Firebase Crashlytics',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize Firebase Cloud Messaging
  Future<void> _initializeMessaging() async {
    try {
      _messaging = FirebaseMessaging.instance;

      // Request permissions for iOS
      await _messaging!.requestPermission();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      AppLogger.info('✅ Firebase Messaging initialized');
    } catch (error, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Firebase Messaging',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize Firebase Remote Config
  Future<void> _initializeRemoteConfig() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Set config settings
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: AppConstants.isDebugMode
              ? const Duration(seconds: 30)
              : const Duration(hours: 1),
        ),
      );

      // Set default parameters
      await _remoteConfig!.setDefaults(_getRemoteConfigDefaults());

      // Fetch and activate
      await _remoteConfig!.fetchAndActivate();

      AppLogger.info('✅ Firebase Remote Config initialized');
    } catch (error, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize Firebase Remote Config',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get default Remote Config parameters
  Map<String, dynamic> _getRemoteConfigDefaults() {
    return {
      'maintenance_mode': false,
      'force_update': false,
      'min_app_version': '1.0.0',
      'show_onboarding': true,
      'enable_biometric_auth': true,
      'max_login_attempts': 5,
      'session_timeout_minutes': 30,
      'enable_analytics': true,
      'enable_crashlytics': true,
      'api_timeout_seconds': 30,
      'retry_attempts': 3,
      'theme_mode': 'system',
      'default_language': 'en',
    };
  }

  /// Log Firebase event
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) async {
    if (_analytics != null && AppConstants.enableAnalytics) {
      await _analytics!.logEvent(name: name, parameters: parameters);
      AppLogger.logAnalytics(event: name, parameters: parameters);
    }
  }

  /// Set user properties
  Future<void> setUserProperties({required String userId, Map<String, String>? properties}) async {
    if (_analytics != null) {
      await _analytics!.setUserId(id: userId);

      if (properties != null) {
        for (final entry in properties.entries) {
          await _analytics!.setUserProperty(name: entry.key, value: entry.value);
        }
      }
    }

    if (_crashlytics != null) {
      await _crashlytics!.setUserIdentifier(userId);

      if (properties != null) {
        for (final entry in properties.entries) {
          await _crashlytics!.setCustomKey(entry.key, entry.value);
        }
      }
    }
  }

  /// Record custom error
  Future<void> recordError({
    required dynamic error,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? context,
  }) async {
    if (_crashlytics != null && AppConstants.enableCrashReporting) {
      // Set context
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics!.setCustomKey(entry.key, entry.value);
        }
      }

      await _crashlytics!.recordError(error, stackTrace, reason: reason, fatal: fatal);
    }
  }

  /// Get Remote Config value
  T getRemoteConfigValue<T>(String key, T defaultValue) {
    if (_remoteConfig == null) return defaultValue;

    try {
      final value = _remoteConfig!.getValue(key);

      if (T == bool) {
        return value.asBool() as T;
      } else if (T == int) {
        return value.asInt() as T;
      } else if (T == double) {
        return value.asDouble() as T;
      } else if (T == String) {
        return value.asString() as T;
      }

      return defaultValue;
    } catch (error) {
      AppLogger.warning('Failed to get remote config value for $key: $error');
      return defaultValue;
    }
  }

  /// Refresh Remote Config
  Future<void> refreshRemoteConfig() async {
    if (_remoteConfig != null) {
      try {
        await _remoteConfig!.fetchAndActivate();
        AppLogger.info('Remote Config refreshed successfully');
      } catch (error, stackTrace) {
        AppLogger.error('Failed to refresh Remote Config', error: error, stackTrace: stackTrace);
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _instance = null;
    _isInitialized = false;
  }
}

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLogger.info('Handling background message: ${message.messageId}');
}
