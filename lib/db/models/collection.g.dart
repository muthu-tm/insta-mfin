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
    ..cusomterNumber = json['customer_number'] as int
    ..collectionDate = json['collection_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['collection_date'] as Timestamp))
    ..collectionAmount = json['collection_amount'] as int
    ..collections = (json['collections'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..status = json['status'] as int ?? 0
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

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_number': instance.cusomterNumber,
      'collection_date': instance.collectionDate,
      'collection_amount': instance.collectionAmount,
      'collections': instance.collections?.map((e) => e?.toJson())?.toList(),
      'status': instance.status,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
