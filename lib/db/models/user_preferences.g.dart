part of 'user_preferences.dart';

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return UserPreferences()
    ..transactionGroupBy = json['transaction_group_by'] as int ?? 0
    ..tableView = json['enable_table_view'] as bool ?? false;
}

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'transaction_group_by':
          instance.transactionGroupBy == null ? 0 : instance.transactionGroupBy,
      'enable_table_view':
          instance.tableView == null ? false : instance.tableView
    };
