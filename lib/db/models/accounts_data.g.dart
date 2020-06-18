part of 'accounts_data.dart';

AccountsData _$AccountsDataFromJson(Map<String, dynamic> json) {
  return AccountsData()
    ..cashInHand = json['cash_in_hand'] as int ?? 0
    ..journalIn = json['journal_in'] as int ?? 0
    ..journalInAmount = json['journal_in_amount'] as int ?? 0
    ..journalOut = json['journal_out'] as int ?? 0
    ..journalOutAmount = json['journal_out_amount'] as int ?? 0
    ..expense = json['expense'] as int ?? 0
    ..expenseAmount = json['expense_amount'] as int ?? 0
    ..totalPayments = json['total_payments'] as int ?? 0
    ..paymentsAmount = json['payments_amount'] as int ?? 0
    ..collectionsAmount = json['collections_amount'] as int ?? 0
    ..penaltyAmount = json['penalty_amount'] as int ?? 0;
}

Map<String, dynamic> _$AccountsDataToJson(AccountsData instance) =>
    <String, dynamic>{
      'cash_in_hand': instance.cashInHand ?? 0,
      'journal_in': instance.journalIn ?? 0,
      'journal_in_amount': instance.journalInAmount ?? 0,
      'journal_out': instance.journalOut ?? 0,
      'journal_out_amount': instance.journalOutAmount ?? 0,
      'expense': instance.expense ?? 0,
      'expense_amount': instance.expenseAmount ?? 0,
      'total_payments': instance.totalPayments ?? 0,
      'payments_amount': instance.paymentsAmount ?? 0,
      'collections_amount': instance.collectionsAmount ?? 0,
      'penalty_amount': instance.penaltyAmount ?? 0
    };
