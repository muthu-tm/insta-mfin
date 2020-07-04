part of 'subscription_data.dart';

SubscriptionData _$SubscriptionDataFromJson(Map<String, dynamic> json) {
  return SubscriptionData()
    ..validTill = json['valid_till'] as int
    ..notes = json['notes'] as String
    ..smsCredit = json['available_sms_credit'] as int
    ..type = json['type'] as int;
}

Map<String, dynamic> _$SubscriptionDataToJson(SubscriptionData instance) =>
    <String, dynamic>{
      'valid_till': instance.validTill,
      'notes': instance.notes,
      'available_sms_credit': instance.smsCredit,
      'type': instance.type,
    };
