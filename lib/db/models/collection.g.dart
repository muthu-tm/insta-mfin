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
    ..collectionDate = json['collection_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['collection_date'] as Timestamp))
    ..collectionDate = json['collection_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['collection_date'] as Timestamp))
    ..collectedOn = (json['collected_on'] as List)
            ?.map((e) => e == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(
                    json['collected_on'] as Timestamp)))
            ?.toList() ??
        []
    ..collectionAmount = json['collection_amount'] as int
    ..collections = (json['collections'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..totalPaid = json['total_paid'] as int ?? 0
    ..status = json['status'] as int ?? 0
    ..type = json['type'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null 
        ? null 
        : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
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
      'total_paid': instance.totalPaid,
      'status': instance.status,
      'type': instance.type,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
