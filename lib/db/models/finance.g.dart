part of 'finance.dart';

Finance _$FinanceFromJson(Map<String, dynamic> json) {
  return Finance()
    ..registrationID = json['registration_id'] as String
    ..financeName = json['finance_name'] as String
    ..contactNumber = json['contact_number'] as String
    ..emailID = json['email'] as String
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..users = (json['users'] as List)?.map((e) => e as int)?.toList()
    ..displayProfilePath = json['display_profile_path'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..dateOfRegistration = json['date_of_registration'] as int
    ..addedBy = json['added_by'] as int
    ..accountsData = json['accounts_data'] == null
        ? new AccountsData()
        : AccountsData.fromJson(json['accounts_data'] as Map<String, dynamic>)
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
      'finance_name': instance.financeName,
      'contact_number': instance.contactNumber ?? '',
      'email': instance.emailID ?? '',
      'admins': instance.admins ?? [instance.addedBy],
      'users': instance.users ?? [instance.addedBy],
      'display_profile_path': instance.displayProfilePath ?? '',
      'address': instance.address?.toJson(),
      'date_of_registration': instance.dateOfRegistration,
      'accounts_data': instance.accountsData?.toJson(),
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
