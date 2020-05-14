// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer()
    ..customerID = json['customer_id'] as String
    ..mobileNumber = json['mobile_number'] as int
    ..name = json['customer_name'] as String
    ..gender = json['gender'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..age = json['age'] as int
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..profession = json['customer_profession'] as String ?? ''
    ..guarantiedBy = json['guarantied_by'] as int
    ..addedBy = json['added_by'] as int
    ..status = json['customer_status'] as int
    ..displayProfilePath = json['display_profile_path'] as String ?? ''
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

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customer_id': instance.customerID == null ? '' : instance.customerID,
      'mobile_number': instance.mobileNumber,
      'customer_name': instance.name == null ? '' : instance.name,
      'gender': instance.gender == null ? '' : instance.gender,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'finance_id': instance.financeID == null ? '' : instance.financeID,
      'address': instance.address?.toJson(),
      'age': instance.age == null ? 0 : instance.age,
      'customer_profession':
          instance.profession == null ? '' : instance.profession,
      'branch_name': instance.branchName == null ? '' : instance.branchName,
      'sub_branch_name':
          instance.subBranchName == null ? '' : instance.subBranchName,
      'guarantied_by': instance.guarantiedBy == null
          ? instance.addedBy
          : instance.guarantiedBy,
      'added_by': instance.addedBy,
      'customer_status':
          instance.status == null ? CustomerStatus.New.name : instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
