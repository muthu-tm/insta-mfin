part of 'purchases.dart';

Purchases _$PurchasesFromJson(Map<String, dynamic> json) {
  return Purchases()
    ..financeID = json['finance_id'] as String
    ..userID = json['user_number'] as int
    ..guid = json['guid'] as String
    ..isSuccess = json['is_success'] as bool
    ..status = json['status'] as int
    ..paymentID = json['payment_id'] as String
    ..plans = (json['plans'] as List)
        ?.map(
            (e) => e == null ? null : Plans.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..notes = json['notes'] as String
    ..totalPaid = json['total_paid'] as int
    ..totalAmount = json['total_amount'] as int
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

Map<String, dynamic> _$PurchasesToJson(Purchases instance) => <String, dynamic>{
      'finance_id': instance.financeID,
      'user_number': instance.userID,
      'guid': instance.guid,
      'is_success': instance.isSuccess,
      'status': instance.status,
      'payment_id': instance.paymentID,
      'plans':
          instance.plans?.map((e) => e == null ? null : e.toJson())?.toList(),
      'notes': instance.notes,
      'total_paid': instance.totalPaid,
      'total_amount': instance.totalAmount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
