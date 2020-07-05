part of 'subscriptions.dart';

Subscriptions _$SubscriptionsFromJson(Map<String, dynamic> json) {
  return Subscriptions()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..paymentID = json['payment_id'] as String
    ..purchaseID = json['purchase_id'] as String
    ..recentlyPaid = json['recently_paid'] as int
    ..chit = json['chit'] == null
        ? null
        : SubscriptionData.fromJson(json['chit'] as Map<String, dynamic>)
    ..service = json['service'] == null
        ? null
        : SubscriptionData.fromJson(json['service'] as Map<String, dynamic>)
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
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'payment_id': instance.paymentID,
      'purchase_id': instance.purchaseID,
      'recently_paid': instance.recentlyPaid,
      'chit': instance.chit?.toJson(),
      'service': instance.service?.toJson(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
