part of 'sub_branch.dart';

SubBranch _$SubBranchFromJson(Map<String, dynamic> json) {
  return SubBranch()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..address = json['address'] == null
        ? new Address()
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..contactNumber = json['contact_number'] as String
    ..emailID = json['email'] as String
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..dateOfRegistration = json['date_of_registration'] as int
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

Map<String, dynamic> _$SubBranchToJson(SubBranch instance) => <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'address': instance.address?.toJson(),
      'contact_number': instance.contactNumber ?? '',
      'email': instance.emailID ?? '',
      'admins': instance.admins ?? [instance.addedBy],
      'date_of_registration': instance.dateOfRegistration,
      'accounts_data': instance.accountsData?.toJson(),
      'preferences': instance.preferences ?? AccountPreferences().toJson(),
      'added_by': instance.addedBy,
      'is_active': instance.isActive,
      'deactivated_at': instance.deactivatedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
