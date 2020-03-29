// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['email'],
    json['name'],
    json['mobileNumber'],
    json['password'],
    json['gender'],
    json['dateOfBirth'],
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'mobileNumber': instance.mobileNumber,
      'password': instance.password,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
    };
