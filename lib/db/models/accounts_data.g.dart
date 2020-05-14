// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountsData _$AccountsDataFromJson(Map<String, dynamic> json) {
  return AccountsData()
    ..cashInHand = json['cash_in_hand'] as int ?? 0
    ..journalIn = json['journal_in'] as int ?? 0
    ..journalInAmount = json['journal_in_amount'] as int ?? 0
    ..journalOut = json['journal_out'] as int ?? 0
    ..journalOutAmount = json['journal_out_amount'] as int ?? 0
    ..miscellaneousExpense = json['miscellaneous_expense'] as int ?? 0
    ..miscellaneousExpenseAmount =
        json['miscellaneous_expense_amount'] as int ?? 0
    ..totalPayments = json['total_payments'] as int ?? 0
    ..paymentsAmount = json['payments_amount'] as int ?? 0
    ..totalCollections = json['total_collections'] as int ?? 0
    ..collectiosAmount = json['collections_amount'] as int ?? 0
    ..pendingCollectios = json['pending_collections'] as int ?? 0
    ..pendingCollectiosAmount = json['pending_collections_amount'] as int ?? 0
    ..upcomingCollectios = json['upcoming_collections'] as int ?? 0
    ..upcomingCollectiosAmount =
        json['upcoming_collections_amount'] as int ?? 0;
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
      'miscellaneous_expense': instance.miscellaneousExpense == null
          ? 0
          : instance.miscellaneousExpense,
      'miscellaneous_expense_amount':
          instance.miscellaneousExpenseAmount == null
              ? 0
              : instance.miscellaneousExpenseAmount,
      'total_payments':
          instance.totalPayments == null ? 0 : instance.totalPayments,
      'payments_amount':
          instance.paymentsAmount == null ? 0 : instance.paymentsAmount,
      'total_collections':
          instance.totalCollections == null ? 0 : instance.totalCollections,
      'collections_amount':
          instance.collectiosAmount == null ? 0 : instance.collectiosAmount,
      'pending_collections':
          instance.pendingCollectios == null ? 0 : instance.pendingCollectios,
      'pending_collections_amount': instance.pendingCollectiosAmount == null
          ? 0
          : instance.pendingCollectiosAmount,
      'upcoming_collections':
          instance.upcomingCollectios == null ? 0 : instance.upcomingCollectios,
      'upcoming_collections_amount': instance.upcomingCollectiosAmount == null
          ? 0
          : instance.upcomingCollectiosAmount,
    };
