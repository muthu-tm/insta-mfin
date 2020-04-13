// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    json['customer_id'] as String,
  )
    ..mobileNumber = json['mobile_number'] as int
    ..name = json['customer_name'] as String
    ..gender = json['gender'] as String
    ..displayProfilePath = json['display_profile_path'] as String ?? ''
    ..dateOfBirth = json['date_of_birth'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..branchID = json['branch_id'] as String
    ..subBranchID = json['sub_branch_id'] as String
    ..lastTransactionType = json['last_transaction_type'] as String ?? ''
    ..lastTransactionTime = json['last_transaction_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(
            json['last_transaction_at'] as Timestamp))
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
      'customer_id': instance.customerID,
      'mobile_number': instance.mobileNumber,
      'customer_name': instance.name,
      'gender': instance.gender,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'date_of_birth': instance.dateOfBirth,
      'address': instance.address?.toJson(),
      'branch_id': instance.branchID,
      'sub_branch_id': instance.subBranchID,
      'last_transaction_type': instance.lastTransactionType,
      'last_transaction_at': instance.lastTransactionTime?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
