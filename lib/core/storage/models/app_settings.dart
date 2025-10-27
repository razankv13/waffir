import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:flutter/material.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class AppSettings with _$AppSettings {
  const AppSettings._();

  const factory AppSettings({
    @HiveField(0) @Default('system') String themeMode,
    @HiveField(1) @Default('en') String languageCode,
    @HiveField(2) @Default(true) bool notificationsEnabled,
    @HiveField(3) @Default(false) bool biometricsEnabled,
    @HiveField(4) @Default(false) bool onboardingCompleted,
    @HiveField(5) DateTime? lastSyncTime,
    @HiveField(6) String? lastKnownVersion,
    @HiveField(7) Map<String, bool>? featureFlags,
    @HiveField(8) Map<String, dynamic>? preferences,
    @HiveField(9) @Default(true) bool analyticsEnabled,
    @HiveField(10) @Default(true) bool crashReportingEnabled,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Locale get locale => Locale(languageCode);

  bool isFeatureEnabled(String featureName) {
    return featureFlags?[featureName] ?? false;
  }

  AppSettings setFeatureFlag(String featureName, bool enabled) {
    final updatedFlags = Map<String, bool>.from(featureFlags ?? {});
    updatedFlags[featureName] = enabled;
    return copyWith(featureFlags: updatedFlags);
  }

  T? getPreference<T>(String key, {T? defaultValue}) {
    if (preferences == null) return defaultValue;
    return preferences![key] as T? ?? defaultValue;
  }

  AppSettings setPreference<T>(String key, T value) {
    final updatedPreferences = Map<String, dynamic>.from(preferences ?? {});
    updatedPreferences[key] = value;
    return copyWith(preferences: updatedPreferences);
  }

  AppSettings removePreference(String key) {
    if (preferences == null) return this;
    final updatedPreferences = Map<String, dynamic>.from(preferences!);
    updatedPreferences.remove(key);
    return copyWith(preferences: updatedPreferences);
  }

  AppSettings setThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return copyWith(themeMode: 'light');
      case ThemeMode.dark:
        return copyWith(themeMode: 'dark');
      case ThemeMode.system:
        return copyWith(themeMode: 'system');
    }
  }
}