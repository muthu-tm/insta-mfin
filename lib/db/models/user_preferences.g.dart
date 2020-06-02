// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return UserPreferences()
    ..paymentGroupBy = json['payment_group_by'] as int ?? 0
    ..transactionGroupBy = json['transaction_group_by'] as int ?? 0
    ..tableView = json['enable_table_view'] as bool ?? false;
}

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'payment_group_by':
          instance.paymentGroupBy == null ? 0 : instance.paymentGroupBy,
      'transaction_group_by':
          instance.transactionGroupBy == null ? 0 : instance.transactionGroupBy,
      'enable_table_view':
          instance.tableView == null ? false : instance.tableView
    };
