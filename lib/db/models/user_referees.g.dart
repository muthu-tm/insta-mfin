part of 'user_referees.dart';

UserReferees _$UserRefereesFromJson(Map<String, dynamic> json) {
  return UserReferees()
    ..userNumber = json['user_number'] as int
    ..guid = json['guid'] as String
    ..amount = json['amount'] as int
    ..type = json['type'] as int
    ..registeredAt = json['registered_at'] as int
    ..subscribedAt = json['subscribed_at'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$UserRefereesToJson(UserReferees instance) =>
    <String, dynamic>{
      'user_number': instance.userNumber,
      'guid': instance.guid,
      'amount': instance.amount,
      'type': instance.type,
      'registered_at': instance.registeredAt,
      'subscribed_at': instance.subscribedAt,
      'created_at': instance.createdAt
    };
