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
    ..customerNumber = json['customer_number'] as int
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
      'customer_number': instance.customerNumber,
      'collection_number': instance.collectionNumber,
      'collection_date': instance.collectionDate,
      'collected_on': instance.collectedOn == null ? [] : instance.collectedOn,
      'collection_amount': instance.collectionAmount,
      'collections': instance.collections?.map((e) => e?.toJson())?.toList(),
      'type': instance.type,
      'created_at': instance.createdAt,
    };
