part of 'customer.dart';

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer()
    ..customerID = json['customer_id'] as String ?? ''
    ..id = json['id'] as int
    ..mobileNumber = json['mobile_number'] as int
    ..name = json['customer_name'] as String
    ..gender = json['gender'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..age = json['age'] as int
    ..joinedAt = json['joined_at'] as int
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..profession = json['customer_profession'] as String ?? ''
    ..guarantiedBy = json['guarantied_by'] as int
    ..addedBy = json['added_by'] as int
    ..status = json['status'] as int ?? 0
    ..profilePathOrg = json['profile_path_org'] as String ?? ''
    ..profilePath = json['profile_path'] as String ?? ''
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(
            _getMicroSecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(
            _getMicroSecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMicroSecondsSinceEpoch(Timestamp ts) {
  return ts.microsecondsSinceEpoch;
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customer_id': instance.customerID ?? '',
      'id': instance.id ?? instance.createdAt.microsecondsSinceEpoch,
      'mobile_number': instance.mobileNumber,
      'customer_name': instance.name ?? '',
      'gender': instance.gender ?? '',
      'profile_path_org': instance.profilePathOrg ?? '',
      'profile_path': instance.profilePath ?? '',
      'finance_id': instance.financeID ?? '',
      'address': instance.address?.toJson(),
      'age': instance.age ?? 0,
      'joined_at': instance.joinedAt ?? 0,
      'customer_profession': instance.profession ?? '',
      'branch_name': instance.branchName ?? '',
      'sub_branch_name': instance.subBranchName ?? '',
      'guarantied_by': instance.guarantiedBy ?? instance.addedBy,
      'added_by': instance.addedBy,
      'status': instance.status ?? 0,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
