part of 'collection_details.dart';

CollectionDetails _$CollectionDetailsFromJson(Map<String, dynamic> json) {
  return CollectionDetails()
    ..collectedOn = json['collected_on'] as int
    ..isPaidLate = json['is_paid_late'] as bool ?? false
    ..amount = json['amount'] as int
    ..penaltyAmount = json['penalty_amount'] as int
    ..transferredMode = json['transferred_mode'] as int
    ..collectedFrom = json['collected_from'] as String ?? ''
    ..collectedBy = json['collected_by'] as String ?? ''
    ..notes = json['notes'] as String ?? ''
    ..addedBy = json['added_by'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$CollectionDetailsToJson(CollectionDetails instance) =>
    <String, dynamic>{
      'collected_on': instance.collectedOn,
      'is_paid_late': instance.isPaidLate ?? false,
      'amount': instance.amount,
      'penalty_amount': instance.penaltyAmount ?? 0,
      'transferred_mode': instance.transferredMode ?? 0,
      'collected_from': instance.collectedFrom ?? '',
      'collected_by': instance.collectedBy ?? '',
      'notes': instance.notes ?? '',
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
    };
