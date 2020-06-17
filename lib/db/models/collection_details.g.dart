part of 'collection_details.dart';

CollectionDetails _$CollectionDetailsFromJson(Map<String, dynamic> json) {
  return CollectionDetails()
    ..collectedOn = json['collected_on'] as int
    ..isPaidLate = json['is_paid_late'] as bool ?? false
    ..amount = json['amount'] as int
    ..penalityAmount = json['penality_amount'] as int
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
      'is_paid_late': instance.isPaidLate == null ? false : instance.isPaidLate,
      'amount': instance.amount,
      'penality_amount':
          instance.penalityAmount == null ? 0 : instance.penalityAmount,
      'transferred_mode':
          instance.transferredMode == null ? 0 : instance.transferredMode,
      'collected_from':
          instance.collectedFrom == null ? '' : instance.collectedFrom,
      'collected_by': instance.collectedBy == null ? '' : instance.collectedBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
    };
