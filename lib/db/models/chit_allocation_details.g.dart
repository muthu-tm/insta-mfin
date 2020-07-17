part of 'chit_allocation_details.dart';

ChitAllocationDetails _$ChitAllocationDetailsFromJson(
    Map<String, dynamic> json) {
  return ChitAllocationDetails()
    ..givenOn = json['given_on'] as int
    ..amount = json['amount'] as int
    ..transferredMode = json['transferred_mode'] as int
    ..givenTo = json['given_to'] as String ?? ''
    ..givenBy = json['given_by'] as String ?? ''
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

Map<String, dynamic> _$ChitAllocationDetailsToJson(
        ChitAllocationDetails instance) =>
    <String, dynamic>{
      'given_on': instance.givenOn,
      'amount': instance.amount,
      'transferred_mode': instance.transferredMode,
      'given_to': instance.givenTo,
      'given_by': instance.givenBy,
      'notes': instance.notes,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
    };
