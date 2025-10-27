import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
    @Default(false) bool emailVerified,
    @Default(false) bool isAnonymous,
    DateTime? createdAt,
    DateTime? lastSignInAt,
    Map<String, dynamic>? metadata,

    // Custom fields for app-specific data
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? country,
    String? language,
    String? timezone,
    @Default([]) List<String> roles,
    @Default({}) Map<String, dynamic> preferences,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  /// Get full name from firstName and lastName or fallback to displayName
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    return displayName ?? email.split('@').first;
  }

  /// Get user initials for avatar
  String get initials {
    final name = fullName;
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return email.substring(0, 1).toUpperCase();
  }

  /// Check if user has a specific role
  bool hasRole(String role) => roles.contains(role);

  /// Check if user is admin
  bool get isAdmin => hasRole('admin') || hasRole('super_admin');

  /// Check if user profile is complete
  bool get isProfileComplete {
    return firstName != null && lastName != null && displayName != null && photoURL != null;
  }

  /// Get user preference with default value
  T getPreference<T>(String key, T defaultValue) {
    final value = preferences[key];
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  /// Copy with updated preference
  UserModel setPreference(String key, dynamic value) {
    final newPreferences = Map<String, dynamic>.from(preferences);
    newPreferences[key] = value;
    return copyWith(preferences: newPreferences);
  }
}
