// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return Collection()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..customerID = json['customer_id'] as int
    ..paymentID = json['payment_id'] as int
    ..payID = json['pay_id'] as String
    ..collectionNumber = json['collection_number'] as int
    ..collectionDate = json['collection_date'] as int
    ..collectedOn = (json['collected_on'] as List)
            ?.map((e) => e == null ? null : e as int)
            ?.toList() ??
        []
    ..collectionAmount = json['collection_amount'] as int
    ..collections = (json['collections'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..type = json['type'] as int
    ..isPaid = json['is_paid'] as bool
    ..isSettled = json['is_settled'] as bool
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_id': instance.customerID,
      'payment_id': instance.paymentID,
      'pay_id': instance.payID,
      'collection_number': instance.collectionNumber,
      'collection_date': instance.collectionDate,
      'collected_on': instance.collectedOn == null ? [] : instance.collectedOn,
      'collection_amount': instance.collectionAmount,
      'collections': instance.collections?.map((e) => e?.toJson())?.toList(),
      'type': instance.type,
      'is_paid': instance.isPaid,
      'is_settled': instance.isSettled,
      'created_at': instance.createdAt,
    };
