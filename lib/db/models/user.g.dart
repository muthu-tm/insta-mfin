// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['mobile_number'],
  )
    ..name = json['user_name'] as String
    ..password = json['password'] as String
    ..gender = json['gender'] as String
    ..displayProfilePath = json['display_profile_path'] as String ?? ''
    ..dateOfBirth = json['date_of_birth'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..lastSignInTime = json['last_signed_in_at'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(_getMillisecondsSinceEpoch(json['last_signed_in_at'] as Timestamp))
    ..primaryCompany = json['primary_company'] as String
    ..primaryBranch = json['primary_branch'] as String
    ..primarySubBranch = json['primary_sub_branch'] as String;
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_name': instance.name,
      'mobile_number': instance.mobileNumber,
      'password': instance.password,
      'gender': instance.gender,
      'display_profile_path': instance.displayProfilePath,
      'date_of_birth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
      'last_signed_in_at': instance.lastSignInTime?.toIso8601String(),
      'primary_company': instance.primaryCompany,
      'primary_branch': instance.primaryBranch,
      'primary_sub_branch': instance.primarySubBranch,
    };
