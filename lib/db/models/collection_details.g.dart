// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionDetails _$CollectionDetailsFromJson(Map<String, dynamic> json) {
  return CollectionDetails()
    ..paidDate = json['paid_date'] == null
        ? null
        : DateTime.parse(json['paid_date'] as String)
    ..isPaidLate = json['is_paid_late'] as bool ?? false
    ..amount = json['amount'] as int
    ..status = json['status'] as int ?? 0
    ..paidBy = json['paid_by'] as String ?? ''
    ..collectedBy = json['collected_by'] as String ?? ''
    ..notes = json['notes'] as String ?? ''
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

Map<String, dynamic> _$CollectionDetailsToJson(CollectionDetails instance) =>
    <String, dynamic>{
      'paid_date': instance.paidDate,
      'is_paid_late': instance.isPaidLate == null ? false : instance.isPaidLate,
      'amount': instance.amount,
      'status': instance.status,
      'paid_by': instance.paidBy == null ? '' : instance.paidBy,
      'collected_by': instance.collectedBy == null ? '' : instance.collectedBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
