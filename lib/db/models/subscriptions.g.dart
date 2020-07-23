part of 'subscriptions.dart';

Subscriptions _$SubscriptionsFromJson(Map<String, dynamic> json) {
  return Subscriptions()
    ..userNumber = json['user_number'] as int
    ..guid = json['guid'] as String
    ..financeID = json['finance_id'] as String
    ..paymentID = json['payment_id'] as String
    ..purchaseID = json['purchase_id'] as String
    ..recentlyPaid = json['recently_paid'] as int
    ..smsCredit = json['available_sms_credit'] as int
    ..chitValidTill = json['chit_valid_till'] as int
    ..finValidTill = json['finance_valid_till'] as int
    ..notes = json['notes'] as String
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

Map<String, dynamic> _$SubscriptionsToJson(Subscriptions instance) =>
    <String, dynamic>{
      'user_number': instance.userNumber,
      'guid': instance.guid,
      'finance_id': instance.financeID,
      'payment_id': instance.paymentID,
      'purchase_id': instance.purchaseID,
      'available_sms_credit': instance.smsCredit,
      'recently_paid': instance.recentlyPaid,
      'chit_valid_till': instance.chitValidTill,
      'finance_valid_till': instance.finValidTill,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
