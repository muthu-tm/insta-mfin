// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['mobile_number'] as int,
  )
    ..name = json['user_name'] as String ?? ''
    ..emailID = json['emailID'] as String ?? ''
    ..password = json['password'] as String
    ..gender = json['gender'] as String ?? ''
    ..displayProfilePath = json['display_profile_path'] as String ?? ''
    ..dateOfBirth = json['date_of_birth'] as String ?? ''
    ..address = json['address'] == null
        ? new Address()
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..preferences = json['preferences'] == null
        ? new UserPreferences()
        : UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
    ..primaryFinance = json['primary_finance'] as String ?? ''
    ..primaryBranch = json['primary_branch'] as String ?? ''
    ..primarySubBranch = json['primary_sub_branch'] as String ?? ''
    ..lastSignInTime = json['last_signed_in_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['last_signed_in_at'] as Timestamp))
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_name': instance.name == null ? '' : instance.name,
      'mobile_number': instance.mobileNumber,
      'emailID': instance.emailID == null ? '' : instance.emailID,
      'password': instance.password,
      'gender': instance.gender == null ? '' : instance.gender,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'date_of_birth': instance.dateOfBirth == null ? '' : instance.dateOfBirth,
      'address': instance.address?.toJson(),
      'preferences': instance.preferences == null
          ? UserPreferences().toJson()
          : instance.preferences,
      'primary_finance':
          instance.primaryFinance == null ? '' : instance.primaryFinance,
      'primary_branch':
          instance.primaryBranch == null ? '' : instance.primaryBranch,
      'primary_sub_branch':
          instance.primarySubBranch == null ? '' : instance.primarySubBranch,
      'last_signed_in_at': instance.lastSignInTime,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
