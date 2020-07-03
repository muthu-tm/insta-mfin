part of 'user_purchases.dart';

UserPurchases _$UserPurchasesFromJson(Map<String, dynamic> json) {
  return UserPurchases()
    ..plans = (json['plans'] as List)
        ?.map(
            (e) => e == null ? null : Plans.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..totalPaid = json['total_paid'] as int ?? 0
    ..purchasedBy = json['purchased_by'] as int ?? 0
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

Map<String, dynamic> _$UserPurchasesToJson(UserPurchases instance) =>
    <String, dynamic>{
      'plans': instance.plans,
      'total_paid': instance.totalPaid,
      'purchased_by': instance.purchasedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
