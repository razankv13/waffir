import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:waffir/core/constants/app_constants.dart';
import 'package:waffir/core/storage/hive_service.dart';
import 'package:waffir/core/storage/models/app_settings.dart';
import 'package:waffir/core/utils/logger.dart';

/// Service for managing app settings using Hive storage
class SettingsService {

  SettingsService._internal() {
    _hiveService = HiveService.instance;
  }
  static SettingsService? _instance;
  late final HiveService _hiveService;
  static const String _settingsKey = 'app_settings';

  static SettingsService get instance {
    _instance ??= SettingsService._internal();
    return _instance!;
  }

  /// Get current app settings
  AppSettings getSettings() {
    try {
      final storedSettings = _hiveService.getSetting<AppSettings>(_settingsKey);
      
      if (storedSettings != null) {
        AppLogger.debug('Retrieved app settings from storage');
        return storedSettings;
      } else {
        AppLogger.info('No stored settings found, returning default settings');
        return _getDefaultSettings();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve app settings, returning defaults',
        error: e,
        stackTrace: stackTrace,
      );
      return _getDefaultSettings();
    }
  }

  /// Save app settings
  Future<void> saveSettings(AppSettings settings) async {
    try {
      await _hiveService.storeSetting(_settingsKey, settings);
      AppLogger.info('App settings saved successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save app settings',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    try {
      final settings = getSettings();
      settings.setThemeMode(themeMode);
      await saveSettings(settings);
      AppLogger.info('Theme mode updated to: ${themeMode.name}');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update theme mode',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update language
  Future<void> updateLanguage(String languageCode) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(languageCode: languageCode);
      await saveSettings(updatedSettings);
      AppLogger.info('Language updated to: $languageCode');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update language',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update notifications enabled
  Future<void> updateNotificationsEnabled(bool enabled) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(notificationsEnabled: enabled);
      await saveSettings(updatedSettings);
      AppLogger.info('Notifications enabled updated to: $enabled');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update notifications setting',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update biometrics enabled
  Future<void> updateBiometricsEnabled(bool enabled) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(biometricsEnabled: enabled);
      await saveSettings(updatedSettings);
      AppLogger.info('Biometrics enabled updated to: $enabled');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update biometrics setting',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(onboardingCompleted: true);
      await saveSettings(updatedSettings);
      AppLogger.info('Onboarding marked as completed');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to mark onboarding as completed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update last sync time
  Future<void> updateLastSyncTime([DateTime? time]) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(
        lastSyncTime: time ?? DateTime.now(),
      );
      await saveSettings(updatedSettings);
      AppLogger.debug('Last sync time updated');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update last sync time',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update app version
  Future<void> updateAppVersion(String version) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(lastKnownVersion: version);
      await saveSettings(updatedSettings);
      AppLogger.info('App version updated to: $version');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update app version',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update analytics enabled
  Future<void> updateAnalyticsEnabled(bool enabled) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(analyticsEnabled: enabled);
      await saveSettings(updatedSettings);
      AppLogger.info('Analytics enabled updated to: $enabled');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update analytics setting',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Update crash reporting enabled
  Future<void> updateCrashReportingEnabled(bool enabled) async {
    try {
      final settings = getSettings();
      final updatedSettings = settings.copyWith(crashReportingEnabled: enabled);
      await saveSettings(updatedSettings);
      AppLogger.info('Crash reporting enabled updated to: $enabled');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update crash reporting setting',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Set feature flag
  Future<void> setFeatureFlag(String featureName, bool enabled) async {
    try {
      final settings = getSettings();
      settings.setFeatureFlag(featureName, enabled);
      await saveSettings(settings);
      AppLogger.info('Feature flag $featureName set to: $enabled');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to set feature flag $featureName',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get feature flag value
  bool isFeatureEnabled(String featureName) {
    try {
      final settings = getSettings();
      return settings.isFeatureEnabled(featureName);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get feature flag $featureName',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Set custom preference
  Future<void> setPreference<T>(String key, T value) async {
    try {
      final settings = getSettings();
      settings.setPreference(key, value);
      await saveSettings(settings);
      AppLogger.debug('Preference $key set');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to set preference $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get custom preference
  T? getPreference<T>(String key, {T? defaultValue}) {
    try {
      final settings = getSettings();
      return settings.getPreference<T>(key, defaultValue: defaultValue);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get preference $key',
        error: e,
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  /// Remove custom preference
  Future<void> removePreference(String key) async {
    try {
      final settings = getSettings();
      settings.removePreference(key);
      await saveSettings(settings);
      AppLogger.debug('Preference $key removed');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to remove preference $key',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Reset all settings to defaults
  Future<void> resetSettings() async {
    try {
      final defaultSettings = _getDefaultSettings();
      await saveSettings(defaultSettings);
      AppLogger.info('Settings reset to defaults');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to reset settings',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Export settings as JSON
  Map<String, dynamic> exportSettings() {
    try {
      final settings = getSettings();
      return settings.toJson();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export settings',
        error: e,
        stackTrace: stackTrace,
      );
      return {};
    }
  }

  /// Import settings from JSON
  Future<void> importSettings(Map<String, dynamic> settingsJson) async {
    try {
      final settings = AppSettings.fromJson(settingsJson);
      await saveSettings(settings);
      AppLogger.info('Settings imported successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to import settings',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get default settings
  AppSettings _getDefaultSettings() {
    return const AppSettings(
      biometricsEnabled: AppConstants.enableBiometrics,
    );
  }
}

/// Riverpod providers for settings
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService.instance;
});

/// Provider for current app settings
final appSettingsProvider = StateProvider<AppSettings>((ref) {
  final settingsService = ref.read(settingsServiceProvider);
  return settingsService.getSettings();
});

/// Provider for theme mode
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.themeModeEnum;
});

/// Provider for current locale
final localeProvider = StateProvider<Locale>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.locale;
});

/// Provider for notifications enabled
final notificationsEnabledProvider = StateProvider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.notificationsEnabled;
});

/// Provider for biometrics enabled
final biometricsEnabledProvider = StateProvider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.biometricsEnabled;
});

/// Provider for onboarding completed
final onboardingCompletedProvider = StateProvider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.onboardingCompleted;
});

/// Provider for analytics enabled
final analyticsEnabledProvider = StateProvider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.analyticsEnabled;
});

/// Provider for crash reporting enabled
final crashReportingEnabledProvider = StateProvider<bool>((ref) {
  final settings = ref.watch(appSettingsProvider);
  return settings.crashReportingEnabled;
});

/// Helper notifier for updating settings
class SettingsNotifier extends StateNotifier<AppSettings> {

  SettingsNotifier(this._settingsService) : super(_settingsService.getSettings());
  final SettingsService _settingsService;

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    await _settingsService.updateThemeMode(themeMode);
    state = _settingsService.getSettings();
  }

  Future<void> updateLanguage(String languageCode) async {
    await _settingsService.updateLanguage(languageCode);
    state = _settingsService.getSettings();
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    await _settingsService.updateNotificationsEnabled(enabled);
    state = _settingsService.getSettings();
  }

  Future<void> updateBiometricsEnabled(bool enabled) async {
    await _settingsService.updateBiometricsEnabled(enabled);
    state = _settingsService.getSettings();
  }

  Future<void> completeOnboarding() async {
    await _settingsService.completeOnboarding();
    state = _settingsService.getSettings();
  }

  Future<void> updateAnalyticsEnabled(bool enabled) async {
    await _settingsService.updateAnalyticsEnabled(enabled);
    state = _settingsService.getSettings();
  }

  Future<void> updateCrashReportingEnabled(bool enabled) async {
    await _settingsService.updateCrashReportingEnabled(enabled);
    state = _settingsService.getSettings();
  }

  Future<void> setFeatureFlag(String featureName, bool enabled) async {
    await _settingsService.setFeatureFlag(featureName, enabled);
    state = _settingsService.getSettings();
  }

  Future<void> setPreference<T>(String key, T value) async {
    await _settingsService.setPreference(key, value);
    state = _settingsService.getSettings();
  }

  Future<void> resetSettings() async {
    await _settingsService.resetSettings();
    state = _settingsService.getSettings();
  }
}

/// Settings notifier provider
final settingsNotifierProvider = 
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final settingsService = ref.read(settingsServiceProvider);
  return SettingsNotifier(settingsService);
});