part of 'account_preferences.dart';

AccountPreferences _$AccountPreferencesFromJson(Map<String, dynamic> json) {
  return AccountPreferences()
    ..reportSignature = json['report_signature'] as String ?? '';
}

Map<String, dynamic> _$AccountPreferencesToJson(AccountPreferences instance) =>
    <String, dynamic>{'report_signature': instance.reportSignature ?? ''};
