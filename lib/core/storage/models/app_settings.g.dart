// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 1;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      themeMode: fields[0] == null ? 'system' : fields[0] as String,
      languageCode: fields[1] == null ? 'en' : fields[1] as String,
      notificationsEnabled: fields[2] == null ? true : fields[2] as bool,
      biometricsEnabled: fields[3] == null ? false : fields[3] as bool,
      onboardingCompleted: fields[4] == null ? false : fields[4] as bool,
      lastSyncTime: fields[5] as DateTime?,
      lastKnownVersion: fields[6] as String?,
      featureFlags: (fields[7] as Map?)?.cast<String, bool>(),
      preferences: (fields[8] as Map?)?.cast<String, dynamic>(),
      analyticsEnabled: fields[9] == null ? true : fields[9] as bool,
      crashReportingEnabled: fields[10] == null ? true : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.languageCode)
      ..writeByte(2)
      ..write(obj.notificationsEnabled)
      ..writeByte(3)
      ..write(obj.biometricsEnabled)
      ..writeByte(4)
      ..write(obj.onboardingCompleted)
      ..writeByte(5)
      ..write(obj.lastSyncTime)
      ..writeByte(6)
      ..write(obj.lastKnownVersion)
      ..writeByte(7)
      ..write(obj.featureFlags)
      ..writeByte(8)
      ..write(obj.preferences)
      ..writeByte(9)
      ..write(obj.analyticsEnabled)
      ..writeByte(10)
      ..write(obj.crashReportingEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  themeMode: json['themeMode'] as String? ?? 'system',
  languageCode: json['languageCode'] as String? ?? 'en',
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  biometricsEnabled: json['biometricsEnabled'] as bool? ?? false,
  onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
  lastSyncTime: json['lastSyncTime'] == null
      ? null
      : DateTime.parse(json['lastSyncTime'] as String),
  lastKnownVersion: json['lastKnownVersion'] as String?,
  featureFlags: (json['featureFlags'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as bool),
  ),
  preferences: json['preferences'] as Map<String, dynamic>?,
  analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
  crashReportingEnabled: json['crashReportingEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'languageCode': instance.languageCode,
      'notificationsEnabled': instance.notificationsEnabled,
      'biometricsEnabled': instance.biometricsEnabled,
      'onboardingCompleted': instance.onboardingCompleted,
      'lastSyncTime': instance.lastSyncTime?.toIso8601String(),
      'lastKnownVersion': instance.lastKnownVersion,
      'featureFlags': instance.featureFlags,
      'preferences': instance.preferences,
      'analyticsEnabled': instance.analyticsEnabled,
      'crashReportingEnabled': instance.crashReportingEnabled,
    };
