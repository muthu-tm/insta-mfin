part of 'subscription_data.dart';

SubscriptionData _$SubscriptionDataFromJson(Map<String, dynamic> json) {
  return SubscriptionData()
    ..name = json['subscription_name'] as String
    ..validTill = json['valid_till'] as int
    ..notes = json['notes'] as String
    ..smsCredit = json['available_sms_credit'] as int
    ..type = json['type'] as int
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$SubscriptionDataToJson(SubscriptionData instance) =>
    <String, dynamic>{
      'subscription_name': instance.name,
      'valid_till': instance.validTill,
      'notes': instance.notes,
      'available_sms_credit': instance.smsCredit,
      'type': instance.type,
      'updated_at': instance.updatedAt,
    };
