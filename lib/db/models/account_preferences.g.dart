part of 'account_preferences.dart';

AccountPreferences _$AccountPreferencesFromJson(Map<String, dynamic> json) {
  return AccountPreferences()
    ..reportSignature = json['report_signature'] as String ?? ''
    ..interestRate = (json['interest_rate'] as num)?.toDouble() ?? 0.00
    ..collectionMode = json['collection_mode'] as int ?? 0
    ..collectionDays = (json['collection_days'] as List)
            ?.map((e) => e == null ? null : e as int)
            ?.toList() ??
        [1, 2, 3, 4, 5];
}

Map<String, dynamic> _$AccountPreferencesToJson(AccountPreferences instance) =>
    <String, dynamic>{
      'report_signature': instance.reportSignature ?? '',
      'collection_mode': instance.collectionMode ?? 0,
      'collection_days': instance.collectionDays ?? [1, 2, 3, 4, 5],
      'interest_rate': instance.interestRate ?? 0.00
    };
