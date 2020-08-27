part of 'finance.dart';

Finance _$FinanceFromJson(Map<String, dynamic> json) {
  return Finance()
    ..registrationID = json['registration_id'] as String
    ..financeID = json['finance_id'] as String
    ..financeName = json['finance_name'] as String
    ..contactNumber = json['contact_number'] as String
    ..emailID = json['email'] as String
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..users = (json['users'] as List)?.map((e) => e as int)?.toList()
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..dateOfRegistration = json['date_of_registration'] as int
    ..profilePath = json['profile_path'] as String ?? ''
    ..addedBy = json['added_by'] as int
    ..isActive = json['is_active'] as bool ?? true
    ..deactivatedAt = json['deactivated_at'] as int
    ..accountsData = json['accounts_data'] == null
        ? new AccountsData()
        : AccountsData.fromJson(json['accounts_data'] as Map<String, dynamic>)
    ..preferences = json['preferences'] == null
        ? new AccountPreferences()
        : AccountPreferences.fromJson(
            json['preferences'] as Map<String, dynamic>)
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

Map<String, dynamic> _$FinanceToJson(Finance instance) => <String, dynamic>{
      'registration_id': instance.registrationID ?? '',
      'finance_id': instance.financeID,
      'finance_name': instance.financeName,
      'contact_number': instance.contactNumber ?? '',
      'email': instance.emailID ?? '',
      'admins': instance.admins ?? [instance.addedBy],
      'users': instance.users ?? [instance.addedBy],
      'address': instance.address?.toJson(),
      'date_of_registration': instance.dateOfRegistration,
      'profile_path': instance.profilePath ?? '',
      'accounts_data': instance.accountsData?.toJson(),
      'preferences': instance.preferences ?? AccountPreferences().toJson(),
      'added_by': instance.addedBy,
      'is_active': instance.isActive,
      'deactivated_at': instance.deactivatedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
