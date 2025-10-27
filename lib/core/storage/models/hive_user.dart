import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'hive_user.freezed.dart';
part 'hive_user.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class HiveUser with _$HiveUser {
  const HiveUser._();

  const factory HiveUser({
    @HiveField(0) required String id,
    @HiveField(1) required String email,
    @HiveField(2) String? firstName,
    @HiveField(3) String? lastName,
    @HiveField(4) String? avatar,
    @HiveField(5) @Default(false) bool isEmailVerified,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) required DateTime updatedAt,
    @HiveField(8) Map<String, dynamic>? metadata,
  }) = _HiveUser;

  factory HiveUser.fromJson(Map<String, dynamic> json) =>
      _$HiveUserFromJson(json);

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else {
      return email;
    }
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null) {
      return firstName![0].toUpperCase();
    } else {
      return email[0].toUpperCase();
    }
  }
}