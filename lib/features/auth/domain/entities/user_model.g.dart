// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final typeId = 2;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      photoURL: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      emailVerified: fields[5] == null ? false : fields[5] as bool,
      isAnonymous: fields[6] == null ? false : fields[6] as bool,
      createdAt: fields[7] as DateTime?,
      lastSignInAt: fields[8] as DateTime?,
      metadata: (fields[9] as Map?)?.cast<String, dynamic>(),
      firstName: fields[10] as String?,
      lastName: fields[11] as String?,
      dateOfBirth: fields[12] as String?,
      gender: fields[13] as String?,
      country: fields[14] as String?,
      language: fields[15] as String?,
      timezone: fields[16] as String?,
      roles: fields[17] == null ? [] : (fields[17] as List).cast<String>(),
      preferences: fields[18] == null
          ? {}
          : (fields[18] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.photoURL)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.emailVerified)
      ..writeByte(6)
      ..write(obj.isAnonymous)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastSignInAt)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.firstName)
      ..writeByte(11)
      ..write(obj.lastName)
      ..writeByte(12)
      ..write(obj.dateOfBirth)
      ..writeByte(13)
      ..write(obj.gender)
      ..writeByte(14)
      ..write(obj.country)
      ..writeByte(15)
      ..write(obj.language)
      ..writeByte(16)
      ..write(obj.timezone)
      ..writeByte(17)
      ..write(obj.roles)
      ..writeByte(18)
      ..write(obj.preferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['displayName'] as String?,
  photoURL: json['photoURL'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  emailVerified: json['emailVerified'] as bool? ?? false,
  isAnonymous: json['isAnonymous'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  lastSignInAt: json['lastSignInAt'] == null
      ? null
      : DateTime.parse(json['lastSignInAt'] as String),
  metadata: json['metadata'] as Map<String, dynamic>?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  gender: json['gender'] as String?,
  country: json['country'] as String?,
  language: json['language'] as String?,
  timezone: json['timezone'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  preferences:
      json['preferences'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'phoneNumber': instance.phoneNumber,
      'emailVerified': instance.emailVerified,
      'isAnonymous': instance.isAnonymous,
      'createdAt': instance.createdAt?.toIso8601String(),
      'lastSignInAt': instance.lastSignInAt?.toIso8601String(),
      'metadata': instance.metadata,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'country': instance.country,
      'language': instance.language,
      'timezone': instance.timezone,
      'roles': instance.roles,
      'preferences': instance.preferences,
    };
