part of 'user_preferences.dart';

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return UserPreferences()
    ..transactionGroupBy = json['transaction_group_by'] as int ?? 0
    ..prefLanguage = json['language'] as String ?? 'English'
    ..isfingerAuthEnabled = json['enable_fingerprint_auth'] as bool ?? false;
}

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'transaction_group_by': instance.transactionGroupBy ?? 0,
      'language': instance.prefLanguage ?? 'English',
      'enable_fingerprint_auth': instance.isfingerAuthEnabled ?? false,
    };
