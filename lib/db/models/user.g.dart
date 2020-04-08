// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['email'],
  )
    ..id = json['id'] as String
    ..name = json['user_name'] as String
    ..mobileNumber = json['mobile_number'] as int
    ..password = json['password'] as String
    ..gender = json['gender'] as String
    ..dateOfBirth = json['date_of_birth'] as String
    ..lastSignInTime = json['last_signed_in_at'] == null
        ? null
        : DateTime.parse(json['last_signed_in_at'] as String)
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..displayProfileLocal = json['display_profile_local'] as String ?? ''
    ..displayProfileCloud = json['display_profile_cloud'] as String ?? '';
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'user_name': instance.name,
      'mobile_number': instance.mobileNumber,
      'password': instance.password,
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth,
      'last_signed_in_at': instance.lastSignInTime?.toIso8601String(),
      'address': instance.address?.toJson(),
      'display_profile_local': instance.displayProfileLocal,
      'display_profile_cloud': instance.displayProfileCloud,
    };
