part of 'accounts_data.dart';

AccountsData _$AccountsDataFromJson(Map<String, dynamic> json) {
  return AccountsData()
    ..cashInHand = json['cash_in_hand'] as int ?? 0
    ..totalDocCharge = json['total_doc_charge'] as int ?? 0
    ..docCharge = json['doc_charge'] as int ?? 0
    ..totalSurCharge = json['total_surcharge'] as int ?? 0
    ..surcharge = json['surcharge'] as int ?? 0
    ..totalPenalty = json['total_penalty'] as int ?? 0
    ..penaltyAmount = json['penalty_amount'] as int ?? 0
    ..totalPayments = json['total_payments'] as int ?? 0
    ..paymentsAmount = json['payments_amount'] as int ?? 0
    ..collectionsAmount = json['collections_amount'] as int ?? 0;
}

Map<String, dynamic> _$AccountsDataToJson(AccountsData instance) =>
    <String, dynamic>{
      'cash_in_hand': instance.cashInHand ?? 0,
      'total_doc_charge': instance.totalDocCharge ?? 0,
      'doc_charge': instance.docCharge ?? 0,
      'total_surcharge': instance.totalSurCharge ?? 0,
      'surcharge': instance.surcharge ?? 0,
      'total_penalty': instance.totalPenalty ?? 0,
      'penalty_amount': instance.penaltyAmount ?? 0,
      'total_payments': instance.totalPayments ?? 0,
      'payments_amount': instance.paymentsAmount ?? 0,
      'collections_amount': instance.collectionsAmount ?? 0
    };
