part of 'chit_collection.dart';

ChitCollection _$ChitCollectionFromJson(Map<String, dynamic> json) {
  return ChitCollection()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..customerNumber = json['customer_number'] as int
    ..chitID = json['chit_id'] as int
    ..chitNumber = json['chit_number'] as int
    ..chitDate = json['chit_date'] as int
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
    ..isPaid = json['is_paid'] as bool
    ..isClosed = json['is_closed'] as bool
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$ChitCollectionToJson(ChitCollection instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_number': instance.customerNumber,
      'chit_id': instance.chitID,
      'chit_number': instance.chitNumber,
      'chit_date': instance.chitDate,
      'collected_on': instance.collectedOn == null ? [] : instance.collectedOn,
      'collection_amount': instance.collectionAmount,
      'collections': instance.collections?.map((e) => e?.toJson())?.toList(),
      'is_paid': instance.isPaid,
      'is_closed': instance.isClosed,
      'created_at': instance.createdAt,
    };
