// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['email'],
  )
    ..name = json['name'] as String
    ..mobileNumber = json['mobileNumber'] as int
    ..password = json['password'] as String
    ..gender = json['gender'] as String
    ..dateOfBirth = json['dateOfBirth'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'mobileNumber': instance.mobileNumber,
      'password': instance.password,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
    };
