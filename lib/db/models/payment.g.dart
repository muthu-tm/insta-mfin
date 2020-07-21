part of 'payment.dart';

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..custName = json['customer_name'] as String
    ..financeID = json['finance_id'] as String
    ..paymentID = json['payment_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..customerID= json['customer_id'] as int
    ..dateOfPayment = json['date_of_payment'] as int
    ..collectionStartsFrom = json['collection_starts_from'] as int
    ..settledDate = json['settled_date'] as int
    ..totalAmount = json['total_amount'] as int
    ..principalAmount = json['principal_amount'] as int
    ..docCharge = json['doc_charge'] as int
    ..surcharge = json['surcharge'] as int
    ..rCommission = json['referral_commission'] as int
    ..tenure = json['tenure'] as int
    ..collectionMode = json['collection_mode'] as int
    ..collectionDays = (json['collection_days'] as List)
            ?.map((e) => e == null ? null : e as int)
            ?.toList() ??
        []
    ..interestRate = (json['interest_rate'] as num)?.toDouble()
    ..collectionAmount = json['collection_amount'] as int
    ..alreadyCollectedAmount = json['already_collected_amount'] as int
    ..transferredMode = json['transferred_mode'] as int
    ..lossAmount = json['loss_amount'] as int
    ..profitAmount = json['profit_amount'] as int
    ..shortageAmount = json['shortage_amount'] as int
    ..isLoss = json['is_loss'] as bool
    ..isSettled = json['is_settled'] as bool
    ..givenBy = json['given_by'] as String
    ..notes = json['notes'] as String ?? ''
    ..addedBy = json['added_by'] as int
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

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'customer_name': instance.custName,
      'finance_id': instance.financeID,
      'payment_id': instance.paymentID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'customer_id': instance.customerID,
      'date_of_payment': instance.dateOfPayment,
      'collection_starts_from': instance.collectionStartsFrom,
      'settled_date': instance.settledDate,
      'total_amount': instance.totalAmount,
      'is_loss': instance.isLoss ?? false,
      'loss_amount': instance.lossAmount ?? 0,
      'profit_amount': instance.profitAmount ?? 0,
      'shortage_amount': instance.shortageAmount ?? 0,
      'principal_amount': instance.principalAmount,
      'doc_charge': instance.docCharge ?? 0,
      'surcharge': instance.surcharge ?? 0,
      'referral_commission': instance.rCommission ?? 0,
      'tenure': instance.tenure,
      'collection_mode': instance.collectionMode,
      'collection_days': instance.collectionDays,
      'already_collected_amount': instance.alreadyCollectedAmount,
      'transferred_mode': instance.transferredMode,
      'interest_rate': instance.interestRate ?? 0,
      'collection_amount': instance.collectionAmount,
      'is_settled': instance.isSettled,
      'given_by': instance.givenBy ?? '',
      'notes': instance.notes ?? '',
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
