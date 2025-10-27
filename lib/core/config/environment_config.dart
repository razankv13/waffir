import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/utils/logger.dart';
import 'package:waffir/flavors.dart';

/// Environment configuration types
enum Environment {
  development,
  staging,
  production,
}

/// Service for managing environment configuration
class EnvironmentConfig {

  EnvironmentConfig._internal();
  static EnvironmentConfig? _instance;
  static Environment _currentEnvironment = Environment.development;

  static EnvironmentConfig get instance {
    _instance ??= EnvironmentConfig._internal();
    return _instance!;
  }

  /// Get current environment
  static Environment get currentEnvironment => _currentEnvironment;

  /// Check if app is in development mode
  static bool get isDevelopment => _currentEnvironment == Environment.development;

  /// Check if app is in staging mode
  static bool get isStaging => _currentEnvironment == Environment.staging;

  /// Check if app is in production mode
  static bool get isProduction => _currentEnvironment == Environment.production;

  /// Initialize environment configuration
  static Future<void> initialize({Environment? environment}) async {
    try {
      AppLogger.info('🌍 Initializing environment configuration');

      // Determine environment from flavor or explicit parameter
      if (environment != null) {
        _currentEnvironment = environment;
      } else {
        _currentEnvironment = _environmentFromFlavor();
      }

      // Load appropriate .env file
      await _loadEnvironmentFile();

      AppLogger.info('✅ Environment configuration initialized for: ${_currentEnvironment.name}');
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ Failed to initialize environment configuration',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Map Flavor to Environment
  static Environment _environmentFromFlavor() {
    try {
      switch (F.appFlavor) {
        case Flavor.dev:
          return Environment.development;
        case Flavor.staging:
          return Environment.staging;
        case Flavor.production:
          return Environment.production;
      }
    } catch (e) {
      // Fall back to old behavior if flavor is not set
      return _determineEnvironment();
    }
  }

  /// Determine environment based on build mode and arguments
  static Environment _determineEnvironment() {
    // Check for environment from dotenv if already loaded
    if (dotenv.isInitialized) {
      final envString = dotenv.env['ENVIRONMENT']?.toLowerCase();
      switch (envString) {
        case 'production':
        case 'prod':
          return Environment.production;
        case 'staging':
        case 'stage':
          return Environment.staging;
        case 'development':
        case 'dev':
        default:
          return Environment.development;
      }
    }

    // Default logic based on build mode
    if (kReleaseMode) {
      return Environment.production;
    } else if (kProfileMode) {
      return Environment.staging;
    } else {
      return Environment.development;
    }
  }

  /// Load appropriate environment file
  static Future<void> _loadEnvironmentFile() async {
    String envFile;
    
    switch (_currentEnvironment) {
      case Environment.production:
        envFile = '.env.production';
        break;
      case Environment.staging:
        envFile = '.env.staging';
        break;
      case Environment.development:
      envFile = '.env.dev';
        break;
    }

    try {
      // Try to load specific environment file first
      await dotenv.load(fileName: envFile);
      AppLogger.info('Loaded environment file: $envFile');
    } catch (e) {
      AppLogger.warning('Could not load $envFile, falling back to .env');
      try {
        // Fall back to default .env file
        await dotenv.load();
        AppLogger.info('Loaded default .env file');
      } catch (e2) {
        AppLogger.warning('Could not load .env file: $e2');
      }
    }
  }

  /// Get environment variable as string
  static String? getString(String key, {String? defaultValue}) {
    if (!dotenv.isInitialized) return defaultValue;
    return dotenv.env[key] ?? defaultValue;
  }

  /// Get environment variable as boolean
  static bool getBool(String key, {bool defaultValue = false}) {
    if (!dotenv.isInitialized) return defaultValue;
    final value = dotenv.env[key]?.toLowerCase();
    return value == 'true' || value == '1' || defaultValue;
  }

  /// Get environment variable as integer
  static int getInt(String key, {int defaultValue = 0}) {
    if (!dotenv.isInitialized) return defaultValue;
    final value = dotenv.env[key];
    return value != null ? int.tryParse(value) ?? defaultValue : defaultValue;
  }

  /// Get environment variable as double
  static double getDouble(String key, {double defaultValue = 0.0}) {
    if (!dotenv.isInitialized) return defaultValue;
    final value = dotenv.env[key];
    return value != null ? double.tryParse(value) ?? defaultValue : defaultValue;
  }

  /// Get list of strings from environment variable (comma-separated)
  static List<String> getStringList(String key, {List<String>? defaultValue}) {
    if (!dotenv.isInitialized) return defaultValue ?? <String>[];
    final value = dotenv.env[key];
    if (value == null) return defaultValue ?? <String>[];
    return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // Convenience getters for common configuration values

  /// API Configuration
  static String get apiBaseUrl => getString('API_BASE_URL', defaultValue: AppConstants.baseUrl)!;
  static String get apiVersion => getString('API_VERSION', defaultValue: AppConstants.apiVersion)!;
  static int get apiTimeout => getInt('API_TIMEOUT', defaultValue: AppConstants.apiTimeout);

  /// Supabase Configuration
  static String? get supabaseUrl => getString('SUPABASE_URL');
  static String? get supabaseAnonKey => getString('SUPABASE_ANON_KEY');

  /// Firebase Configuration
  static String get firebaseOptionsName => getString('FIREBASE_OPTIONS_NAME', defaultValue: 'dev')!;

  /// RevenueCat Configuration
  static String? get revenueCatApiKey => getString('REVENUECAT_API_KEY');

  /// Google AdMob Configuration
  static String get adMobAppIdAndroid => getString('ADMOB_APP_ID_ANDROID', defaultValue: _getTestAdMobAppId('android'))!;
  static String get adMobAppIdIOS => getString('ADMOB_APP_ID_IOS', defaultValue: _getTestAdMobAppId('ios'))!;

  // Banner Ad Unit IDs
  static String get bannerAdUnitIdAndroid => getString('BANNER_AD_UNIT_ID_ANDROID', defaultValue: _getTestAdUnitId('banner', 'android'))!;
  static String get bannerAdUnitIdIOS => getString('BANNER_AD_UNIT_ID_IOS', defaultValue: _getTestAdUnitId('banner', 'ios'))!;

  // Interstitial Ad Unit IDs
  static String get interstitialAdUnitIdAndroid => getString('INTERSTITIAL_AD_UNIT_ID_ANDROID', defaultValue: _getTestAdUnitId('interstitial', 'android'))!;
  static String get interstitialAdUnitIdIOS => getString('INTERSTITIAL_AD_UNIT_ID_IOS', defaultValue: _getTestAdUnitId('interstitial', 'ios'))!;

  // Rewarded Ad Unit IDs
  static String get rewardedAdUnitIdAndroid => getString('REWARDED_AD_UNIT_ID_ANDROID', defaultValue: _getTestAdUnitId('rewarded', 'android'))!;
  static String get rewardedAdUnitIdIOS => getString('REWARDED_AD_UNIT_ID_IOS', defaultValue: _getTestAdUnitId('rewarded', 'ios'))!;

  // Native Ad Unit IDs
  static String get nativeAdUnitIdAndroid => getString('NATIVE_AD_UNIT_ID_ANDROID', defaultValue: _getTestAdUnitId('native', 'android'))!;
  static String get nativeAdUnitIdIOS => getString('NATIVE_AD_UNIT_ID_IOS', defaultValue: _getTestAdUnitId('native', 'ios'))!;

  /// Sentry Configuration
  static String? get sentryDsn => getString('SENTRY_DSN');
  static String get sentryEnvironment => getString('SENTRY_ENVIRONMENT', defaultValue: _currentEnvironment.name)!;

  /// Clarity Configuration
  static String? get clarityProjectId => getString('CLARITY_PROJECT_ID');
  static bool get enableClarity => getBool('ENABLE_CLARITY', defaultValue: true);

  /// Feature Flags
  static bool get enableAnalytics => getBool('ENABLE_ANALYTICS', defaultValue: AppConstants.enableAnalytics);
  static bool get enableCrashReporting => getBool('ENABLE_CRASH_REPORTING', defaultValue: AppConstants.enableCrashReporting);
  static bool get enablePerformanceMonitoring => getBool('ENABLE_PERFORMANCE_MONITORING', defaultValue: AppConstants.enablePerformanceMonitoring);
  static bool get enableDebugMode => getBool('ENABLE_DEBUG_MODE', defaultValue: AppConstants.enableDebugMode);
  static bool get enableBiometrics => getBool('ENABLE_BIOMETRICS', defaultValue: AppConstants.enableBiometrics);
  static bool get enableNotifications => getBool('ENABLE_NOTIFICATIONS', defaultValue: AppConstants.enableNotifications);
  static bool get enableRemoteConfig => getBool('ENABLE_REMOTE_CONFIG', defaultValue: AppConstants.enableRemoteConfig);

  /// Ad Configuration Flags
  static bool get enableAds => getBool('ENABLE_ADS', defaultValue: true);
  static bool get enableAdPersonalization => getBool('ENABLE_AD_PERSONALIZATION');
  static bool get enableTestAds => getBool('ENABLE_TEST_ADS', defaultValue: !isProduction);
  static bool get requireConsentForAds => getBool('REQUIRE_CONSENT_FOR_ADS', defaultValue: true);
  static int get interstitialAdFrequency => getInt('INTERSTITIAL_AD_FREQUENCY', defaultValue: 3); // Show every 3rd time

  /// Social Login Configuration
  static String get googleClientIdAndroid => getString('GOOGLE_CLIENT_ID_ANDROID', defaultValue: AppConstants.googleClientIdAndroid)!;
  static String get googleClientIdIOS => getString('GOOGLE_CLIENT_ID_IOS', defaultValue: AppConstants.googleClientIdIOS)!;
  static String get appleClientId => getString('APPLE_CLIENT_ID', defaultValue: AppConstants.appleClientId)!;

  /// Deep Links
  static String get deepLinkScheme => getString('DEEP_LINK_SCHEME', defaultValue: AppConstants.deepLinkScheme)!;
  static String get deepLinkHost => getString('DEEP_LINK_HOST', defaultValue: AppConstants.deepLinkHost)!;

  /// External URLs
  static String get privacyPolicyUrl => getString('PRIVACY_POLICY_URL', defaultValue: AppConstants.privacyPolicyUrl)!;
  static String get termsOfServiceUrl => getString('TERMS_OF_SERVICE_URL', defaultValue: AppConstants.termsOfServiceUrl)!;
  static String get supportUrl => getString('SUPPORT_URL', defaultValue: AppConstants.supportUrl)!;
  static String get websiteUrl => getString('WEBSITE_URL', defaultValue: AppConstants.websiteUrl)!;

  /// App Store Configuration
  static String get androidAppId => getString('ANDROID_APP_ID', defaultValue: AppConstants.androidAppId)!;
  static String get iosAppId => getString('IOS_APP_ID', defaultValue: AppConstants.iosAppId)!;
  static String get appStoreUrl => getString('APP_STORE_URL', defaultValue: AppConstants.appStoreUrl)!;
  static String get playStoreUrl => getString('PLAY_STORE_URL', defaultValue: AppConstants.playStoreUrl)!;

  /// Development Tools
  static bool get enableInspector => getBool('ENABLE_INSPECTOR', defaultValue: !kReleaseMode);
  static bool get enablePerformanceOverlay => getBool('ENABLE_PERFORMANCE_OVERLAY');
  static String get logLevel => getString('LOG_LEVEL', defaultValue: kDebugMode ? 'debug' : 'info')!;

  /// Get app package name based on environment
  static String get packageName {
    final platform = Platform.isAndroid ? 'android' : 'ios';
    final envMap = platform == 'android' 
        ? AppConstants.androidPackageName 
        : AppConstants.iosBundleId;
    
    switch (_currentEnvironment) {
      case Environment.production:
        return envMap['production'] ?? envMap['dev'] ?? '';
      case Environment.staging:
        return envMap['staging'] ?? envMap['dev'] ?? '';
      case Environment.development:
      return envMap['dev'] ?? '';
    }
  }

  /// Get app name with environment suffix
  static String get appName {
    String baseName = AppConstants.appName;

    switch (_currentEnvironment) {
      case Environment.production:
        return baseName;
      case Environment.staging:
        return '$baseName (Staging)';
      case Environment.development:
        return '$baseName (Dev)';
    }
  }

  /// Print current configuration (for debugging)
  static void printConfiguration() {
    if (!kDebugMode && !isDevelopment) return;

    AppLogger.info('📋 Current Environment Configuration:');
    AppLogger.info('  Environment: ${_currentEnvironment.name}');
    AppLogger.info('  App Name: $appName');
    AppLogger.info('  Package Name: $packageName');
    AppLogger.info('  API Base URL: $apiBaseUrl');
    AppLogger.info('  Debug Mode: $enableDebugMode');
    AppLogger.info('  Analytics: $enableAnalytics');
    AppLogger.info('  Crash Reporting: $enableCrashReporting');
    
    if (supabaseUrl != null) {
      AppLogger.info('  Supabase URL: ${supabaseUrl!.replaceRange(20, null, '...')}');
    }
    
    if (sentryDsn != null) {
      AppLogger.info('  Sentry DSN: ${sentryDsn!.substring(0, 20)}...');
    }
  }

  /// Export configuration as map (for debugging/support)
  static Map<String, dynamic> exportConfiguration() {
    return {
      'environment': _currentEnvironment.name,
      'appName': appName,
      'packageName': packageName,
      'apiBaseUrl': apiBaseUrl,
      'apiVersion': apiVersion,
      'enableAnalytics': enableAnalytics,
      'enableCrashReporting': enableCrashReporting,
      'enableDebugMode': enableDebugMode,
      'hasSupabaseConfig': supabaseUrl != null,
      'hasSentryConfig': sentryDsn != null,
      'hasRevenueCatConfig': revenueCatApiKey != null,
      'enableAds': enableAds,
      'enableTestAds': enableTestAds,
    };
  }

  // Helper methods for Google AdMob test IDs
  static String _getTestAdMobAppId(String platform) {
    // These are Google's official test app IDs
    switch (platform.toLowerCase()) {
      case 'android':
        return 'ca-app-pub-3940256099942544~3347511713';
      case 'ios':
        return 'ca-app-pub-3940256099942544~1458002511';
      default:
        return '';
    }
  }

  static String _getTestAdUnitId(String adType, String platform) {
    // These are Google's official test ad unit IDs
    if (platform.toLowerCase() == 'android') {
      switch (adType.toLowerCase()) {
        case 'banner':
          return 'ca-app-pub-3940256099942544/6300978111';
        case 'interstitial':
          return 'ca-app-pub-3940256099942544/1033173712';
        case 'rewarded':
          return 'ca-app-pub-3940256099942544/5224354917';
        case 'native':
          return 'ca-app-pub-3940256099942544/2247696110';
        default:
          return '';
      }
    } else if (platform.toLowerCase() == 'ios') {
      switch (adType.toLowerCase()) {
        case 'banner':
          return 'ca-app-pub-3940256099942544/2934735716';
        case 'interstitial':
          return 'ca-app-pub-3940256099942544/4411468910';
        case 'rewarded':
          return 'ca-app-pub-3940256099942544/1712485313';
        case 'native':
          return 'ca-app-pub-3940256099942544/3986624511';
        default:
          return '';
      }
    }
    return '';
  }
}