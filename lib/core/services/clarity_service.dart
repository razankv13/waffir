import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:waffir/core/config/environment_config.dart';
import 'package:waffir/core/utils/logger.dart';

/// Service for managing Microsoft Clarity analytics
///
/// This service provides a wrapper around the Clarity Flutter SDK
/// for session recording and user behavior analytics.
class ClarityService {
  ClarityService._internal();

  static ClarityService? _instance;
  static ClarityService get instance {
    _instance ??= ClarityService._internal();
    return _instance!;
  }

  bool _isInitialized = false;
  ClarityConfig? _config;

  /// Check if Clarity is initialized
  bool get isInitialized => _isInitialized;

  /// Get the current Clarity configuration
  ClarityConfig? get config => _config;

  /// Initialize Clarity SDK
  ///
  /// Returns the ClarityConfig if initialization is successful,
  /// null if Clarity is disabled or project ID is not configured.
  Future<ClarityConfig?> initialize({String? projectId, LogLevel? logLevel}) async {
    try {
      AppLogger.info('📊 Initializing Clarity');

      // Check if Clarity is enabled
      if (!EnvironmentConfig.enableClarity) {
        AppLogger.info('📊 Clarity is disabled in configuration');
        return null;
      }

      // Get project ID from parameters or environment
      final clarityProjectId = projectId ?? EnvironmentConfig.clarityProjectId;

      if (clarityProjectId == null || clarityProjectId.isEmpty) {
        AppLogger.warning('⚠️ Clarity project ID not found in environment');
        return null;
      }

      // Determine log level based on environment
      final clarityLogLevel = logLevel ?? _getDefaultLogLevel();

      // Create Clarity configuration (userId is deprecated, use setCustomUserId instead)
      _config = ClarityConfig(projectId: clarityProjectId, logLevel: clarityLogLevel);

      _isInitialized = true;

      AppLogger.info('✅ Clarity initialized successfully');
      AppLogger.info('   Project ID: $clarityProjectId');
      AppLogger.info('   Log Level: ${clarityLogLevel.toString()}');

      return _config;
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to initialize Clarity', error: e, stackTrace: stackTrace);
      _isInitialized = false;
      return null;
    }
  }

  /// Get default log level based on environment
  LogLevel _getDefaultLogLevel() {
    if (EnvironmentConfig.isProduction) {
      return LogLevel.None;
    } else if (EnvironmentConfig.enableDebugMode) {
      return LogLevel.Verbose;
    } else {
      return LogLevel.Info;
    }
  }

  /// Set custom user ID
  ///
  /// Use this method to set a custom user ID for Clarity tracking.
  /// This is the recommended way to set user ID (not via ClarityConfig).
  Future<void> setCustomUserId(String userId) async {
    try {
      if (!_isInitialized) {
        AppLogger.warning('⚠️ Clarity not initialized, cannot set user ID');
        return;
      }

      Clarity.setCustomUserId(userId);
      AppLogger.info('📊 Clarity custom user ID set: $userId');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to set Clarity user ID', error: e, stackTrace: stackTrace);
    }
  }

  /// Log custom event (if supported by SDK)
  void logEvent(String eventName, {Map<String, dynamic>? properties}) {
    if (!_isInitialized) {
      AppLogger.warning('⚠️ Clarity not initialized, cannot log event: $eventName');
      return;
    }

    AppLogger.debug('📊 Clarity event logged: $eventName');
    // Note: As of Clarity Flutter SDK 1.0, custom events are automatically tracked
    // This method is provided for future extensibility
  }

  /// Print current configuration (for debugging)
  void printConfiguration() {
    if (!kDebugMode && !EnvironmentConfig.isDevelopment) return;

    AppLogger.info('📋 Clarity Configuration:');
    AppLogger.info('  Initialized: $_isInitialized');
    AppLogger.info('  Enabled: ${EnvironmentConfig.enableClarity}');

    if (_config != null) {
      AppLogger.info('  Project ID: ${_config!.projectId}');
      AppLogger.info('  Log Level: ${_config!.logLevel}');
    }
  }

  /// Get configuration as map (for debugging/support)
  Map<String, dynamic> exportConfiguration() {
    return {
      'initialized': _isInitialized,
      'enabled': EnvironmentConfig.enableClarity,
      'hasProjectId': _config?.projectId != null,
      'logLevel': _config?.logLevel.toString(),
    };
  }

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
    _config = null;
    AppLogger.info('📊 Clarity service disposed');
  }
}
