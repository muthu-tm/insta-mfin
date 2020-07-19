part of 'chit_requesters.dart';

ChitRequesters _$ChitRequestersFromJson(Map<String, dynamic> json) {
  return ChitRequesters()
    ..chitNumber = json['chit_number'] as int
    ..custNumber = json['customer_number'] as int
    ..requestedAt = json['requested_at'] as int
    ..requestedChits = json['requested_chits'] as int
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

Map<String, dynamic> _$ChitRequestersToJson(ChitRequesters instance) =>
    <String, dynamic>{
      'chit_number': instance.chitNumber,
      'customer_number': instance.custNumber,
      'requested_at': instance.requestedAt,
      'requested_chits': instance.requestedChits,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
