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
    ..collectionsAmount = json['collections_amount'] as int ?? 0;
}

Map<String, dynamic> _$AccountsDataToJson(AccountsData instance) =>
    <String, dynamic>{
      'cash_in_hand': instance.cashInHand == null ? 0 : instance.cashInHand,
      'journal_in': instance.journalIn == null ? 0 : instance.journalIn,
      'journal_in_amount':
          instance.journalInAmount == null ? 0 : instance.journalInAmount,
      'journal_out': instance.journalOut == null ? 0 : instance.journalOut,
      'journal_out_amount':
          instance.journalOutAmount == null ? 0 : instance.journalOutAmount,
      'expense': instance.expense == null ? 0 : instance.expense,
      'expense_amount':
          instance.expenseAmount == null ? 0 : instance.expenseAmount,
      'total_payments':
          instance.totalPayments == null ? 0 : instance.totalPayments,
      'payments_amount':
          instance.paymentsAmount == null ? 0 : instance.paymentsAmount,
      'collections_amount':
          instance.collectionsAmount == null ? 0 : instance.collectionsAmount
    };
