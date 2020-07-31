part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['mobile_number'] as int,
  )
    ..guid = json['guid'] as String ?? ''
    ..referrerNumber = json['referrer_number'] as int
    ..name = json['user_name'] as String ?? ''
    ..emailID = json['emailID'] as String ?? ''
    ..password = json['password'] as String
    ..gender = json['gender'] as String ?? ''
    ..profilePathOrg = json['profile_path_org'] as String ?? ''
    ..profilePath = json['profile_path'] as String ?? ''
    ..dateOfBirth = json['date_of_birth'] as int
    ..address = json['address'] == null
        ? new Address()
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..preferences = json['preferences'] == null
        ? new UserPreferences()
        : UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
    ..primary = json['primary'] == null
        ? new UserPrimary()
        : UserPrimary.fromJson(json['primary'] as Map<String, dynamic>)
    ..wallet = json['wallet'] == null
        ? new UserWallet()
        : UserWallet.fromJson(json['wallet'] as Map<String, dynamic>)
    ..lastSignInTime = json['last_signed_in_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['last_signed_in_at'] as Timestamp))
    ..isActive = json['is_active'] as bool ?? true
    ..deactivatedAt = json['deactivated_at'] as int
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
      'guid': instance.guid,
      'user_name': instance.name ?? '',
      'mobile_number': instance.mobileNumber,
      'referrer_number': instance.referrerNumber,
      'emailID': instance.emailID ?? '',
      'password': instance.password,
      'gender': instance.gender ?? '',
      'profile_path_org': instance.profilePathOrg ?? '',
      'profile_path': instance.profilePath ?? '',
      'date_of_birth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
      'preferences': instance.preferences?.toJson(),
      'primary': instance.primary?.toJson(),
      'wallet': instance.wallet?.toJson(),
      'last_signed_in_at': instance.lastSignInTime,
      'is_active': instance.isActive,
      'deactivated_at': instance.deactivatedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
