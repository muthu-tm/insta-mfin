// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coll_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionTemp _$CollectionTempFromJson(Map<String, dynamic> json) {
  return CollectionTemp()
    ..name = json['template_name'] as String
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..tenure = json['tenure'] as int
    ..tenureType = json['tenure_type'] as int
    ..collectionAmount = json['collection_amount'] as int
    ..interestRate = json['interest_rate'] as double
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

Map<String, dynamic> _$CollectionTempToJson(CollectionTemp instance) =>
    <String, dynamic>{
      'template_name': instance.name,
      'total_amount': instance.totalAmount == null ? 0 : instance.totalAmount,
      'principal_amount':
          instance.principalAmount == null ? 0 : instance.principalAmount,
      'doc_charge': instance.docCharge == null ? 0 : instance.docCharge,
      'surcharge': instance.surcharge == null ? 0 : instance.surcharge,
      'tenure': instance.tenure == null ? 0 : instance.tenure,
      'tenure_type': instance.tenureType == null ? 0 : instance.tenureType,
      'collection_amount':
          instance.collectionAmount == null ? 0 : instance.collectionAmount,
      'interest_rate':
          instance.interestRate == null ? 0.0 : instance.interestRate,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
