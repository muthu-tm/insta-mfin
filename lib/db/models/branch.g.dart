part of 'branch.dart';

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return Branch()
    ..branchName = json['branch_name'] as String
    ..address = json['address'] == null
        ? new Address()
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..accountsData = json['accounts_data'] == null
        ? new AccountsData()
        : AccountsData.fromJson(json['accounts_data'] as Map<String, dynamic>)
    ..emailID = json['email'] as String
    ..contactNumber = json['contact_number'] as String
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..users = (json['users'] as List)?.map((e) => e as int)?.toList()
    ..dateOfRegistration = json['date_of_registration'] as String
    ..addedBy = json['added_by'] as int
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

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'finance': instance.finance?.toJson(),
      'branch_name': instance.branchName == null ? '' : instance.branchName,
      'address': instance.address?.toJson(),
      'contact_number':
          instance.contactNumber == null ? '' : instance.contactNumber,
      'email': instance.emailID == null ? '' : instance.emailID,
      'admins': instance.admins == null ? [instance.addedBy] : instance.admins,
      'users': instance.users == null ? [instance.addedBy] : instance.users,
      'date_of_registration': instance.dateOfRegistration == null
          ? ''
          : instance.dateOfRegistration,
      'accounts_data': instance.accountsData?.toJson(),
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
