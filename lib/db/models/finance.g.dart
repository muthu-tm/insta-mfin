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
    ..allocatedBranchCount = json['allocated_branch_count'] as int
    ..availableBranchCount = json['available_branch_count'] as int
    ..allocatedUsersCount = json['allocated_users_count'] as int
    ..availableUsersCount = json['available_users_count'] as int
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
      'registration_id':
          instance.registrationID == null ? '' : instance.registrationID,
      'finance_name': instance.financeName,
      'contact_number': instance.contactNumber == null ? '' : instance.contactNumber,
      'email': instance.emailID == null ? '' : instance.emailID,
      'admins': instance.admins == null ? [instance.addedBy] : instance.admins,
      'users': instance.users == null ? [instance.addedBy] : instance.users,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'address': instance.address?.toJson(),
      'date_of_registration': instance.dateOfRegistration,
      'allocated_branch_count': instance.allocatedBranchCount == null
          ? 1
          : instance.allocatedBranchCount,
      'available_branch_count': instance.availableBranchCount == null
          ? 1
          : instance.availableBranchCount,
      'allocated_users_count': instance.allocatedUsersCount == null
          ? 1
          : instance.allocatedUsersCount,
      'available_users_count': instance.availableUsersCount == null
          ? 1
          : instance.availableUsersCount,
      'accounts_data': instance.accountsData?.toJson(),
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
