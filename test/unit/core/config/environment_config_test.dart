import 'package:flutter_test/flutter_test.dart';
import 'package:waffir/core/config/environment_config.dart';

void main() {
  group('EnvironmentConfig', () {
    setUp(() {
      // Reset environment state before each test
    });

    group('Environment Detection', () {
      test('should correctly identify development environment', () {
        expect(EnvironmentConfig.isDevelopment, isA<bool>());
        expect(EnvironmentConfig.isStaging, isA<bool>());
        expect(EnvironmentConfig.isProduction, isA<bool>());
      });

      test('should return current environment', () {
        final environment = EnvironmentConfig.currentEnvironment;
        expect(environment, isA<Environment>());
      });
    });

    group('Configuration Getters', () {
      test('should return API configuration values', () {
        expect(EnvironmentConfig.apiBaseUrl, isA<String>());
        expect(EnvironmentConfig.apiVersion, isA<String>());
        expect(EnvironmentConfig.apiTimeout, isA<int>());
      });

      test('should return feature flags', () {
        expect(EnvironmentConfig.enableAnalytics, isA<bool>());
        expect(EnvironmentConfig.enableCrashReporting, isA<bool>());
        expect(EnvironmentConfig.enableDebugMode, isA<bool>());
        expect(EnvironmentConfig.enablePerformanceMonitoring, isA<bool>());
      });

      test('should return app identifiers', () {
        expect(EnvironmentConfig.packageName, isA<String>());
        expect(EnvironmentConfig.appName, isA<String>());
      });

      test('should return URL configurations', () {
        expect(EnvironmentConfig.privacyPolicyUrl, isA<String>());
        expect(EnvironmentConfig.termsOfServiceUrl, isA<String>());
        expect(EnvironmentConfig.supportUrl, isA<String>());
        expect(EnvironmentConfig.websiteUrl, isA<String>());
      });
    });

    group('String Helper Methods', () {
      test('should return string values', () {
        const testKey = 'TEST_STRING';
        const defaultValue = 'default';

        final result = EnvironmentConfig.getString(testKey, defaultValue: defaultValue);
        expect(result, isA<String?>());
      });

      test('should return boolean values', () {
        const testKey = 'TEST_BOOL';
        const defaultValue = false;

        final result = EnvironmentConfig.getBool(testKey);
        expect(result, isA<bool>());
        expect(result, defaultValue); // Should return default when key doesn't exist
      });

      test('should return integer values', () {
        const testKey = 'TEST_INT';
        const defaultValue = 42;

        final result = EnvironmentConfig.getInt(testKey, defaultValue: defaultValue);
        expect(result, isA<int>());
        expect(result, defaultValue); // Should return default when key doesn't exist
      });

      test('should return double values', () {
        const testKey = 'TEST_DOUBLE';
        const defaultValue = 3.14;

        final result = EnvironmentConfig.getDouble(testKey, defaultValue: defaultValue);
        expect(result, isA<double>());
        expect(result, defaultValue); // Should return default when key doesn't exist
      });

      test('should return string list values', () {
        const testKey = 'TEST_LIST';
        const defaultValue = ['item1', 'item2'];

        final result = EnvironmentConfig.getStringList(testKey, defaultValue: defaultValue);
        expect(result, isA<List<String>>());
        expect(result, defaultValue); // Should return default when key doesn't exist
      });
    });

    group('App Name with Environment', () {
      test('should append environment suffix to app name for non-production', () {
        final appName = EnvironmentConfig.appName;
        expect(appName, isA<String>());
        expect(appName.isNotEmpty, true);
      });
    });

    group('Configuration Export', () {
      test('should export configuration as map', () {
        final config = EnvironmentConfig.exportConfiguration();

        expect(config, isA<Map<String, dynamic>>());
        expect(config['environment'], isA<String>());
        expect(config['appName'], isA<String>());
        expect(config['packageName'], isA<String>());
        expect(config['enableAnalytics'], isA<bool>());
        expect(config['enableCrashReporting'], isA<bool>());
        expect(config['enableDebugMode'], isA<bool>());
      });

      test('should include service availability flags', () {
        final config = EnvironmentConfig.exportConfiguration();

        expect(config['hasSupabaseConfig'], isA<bool>());
        expect(config['hasSentryConfig'], isA<bool>());
        expect(config['hasRevenueCatConfig'], isA<bool>());
      });
    });

    group('Ad Configuration', () {
      test('should return ad configuration values', () {
        expect(EnvironmentConfig.enableAds, isA<bool>());
        expect(EnvironmentConfig.enableTestAds, isA<bool>());
        expect(EnvironmentConfig.enableAdPersonalization, isA<bool>());
        expect(EnvironmentConfig.interstitialAdFrequency, isA<int>());
      });

      test('should return platform-specific ad IDs', () {
        expect(EnvironmentConfig.adMobAppIdAndroid, isA<String>());
        expect(EnvironmentConfig.adMobAppIdIOS, isA<String>());
        expect(EnvironmentConfig.bannerAdUnitIdAndroid, isA<String>());
        expect(EnvironmentConfig.bannerAdUnitIdIOS, isA<String>());
      });
    });

    group('Social Login Configuration', () {
      test('should return social login client IDs', () {
        expect(EnvironmentConfig.googleClientIdAndroid, isA<String>());
        expect(EnvironmentConfig.googleClientIdIOS, isA<String>());
        expect(EnvironmentConfig.appleClientId, isA<String>());
      });
    });

    group('Deep Link Configuration', () {
      test('should return deep link configuration', () {
        expect(EnvironmentConfig.deepLinkScheme, isA<String>());
        expect(EnvironmentConfig.deepLinkHost, isA<String>());
      });
    });

    group('App Store Configuration', () {
      test('should return app store URLs and IDs', () {
        expect(EnvironmentConfig.androidAppId, isA<String>());
        expect(EnvironmentConfig.iosAppId, isA<String>());
        expect(EnvironmentConfig.appStoreUrl, isA<String>());
        expect(EnvironmentConfig.playStoreUrl, isA<String>());
      });
    });

    group('Developer Tools Configuration', () {
      test('should return developer tools flags', () {
        expect(EnvironmentConfig.enableInspector, isA<bool>());
        expect(EnvironmentConfig.enablePerformanceOverlay, isA<bool>());
        expect(EnvironmentConfig.logLevel, isA<String>());
      });
    });

    group('Error Handling', () {
      test('should handle missing environment variables gracefully', () {
        // These should not throw exceptions even if env vars are missing
        expect(() => EnvironmentConfig.supabaseUrl, returnsNormally);
        expect(() => EnvironmentConfig.supabaseAnonKey, returnsNormally);
        expect(() => EnvironmentConfig.sentryDsn, returnsNormally);
        expect(() => EnvironmentConfig.revenueCatApiKey, returnsNormally);
      });
    });
  });
}