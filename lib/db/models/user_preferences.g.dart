// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) {
  return UserPreferences()
    ..paymentGroupBy = json['payment_group_by'] as int ?? 0
    ..transactionGroupBy = json['transaction_group_by'] as int ?? 0
    ..collectionNotificationAt =
        json['collection_notification_at'] as String ?? '09:00'
    ..collectionCheckAt = json['collection_check_at'] as String ?? '09:00';
}

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'payment_group_by': instance.paymentGroupBy == null
          ? 0
          : instance.paymentGroupBy,
      'transaction_group_by': instance.transactionGroupBy == null
          ? 0
          : instance.transactionGroupBy,
      'collection_notification_at': instance.collectionNotificationAt == null
          ? "09:00"
          : instance.collectionNotificationAt,
      'collection_check_at': instance.collectionCheckAt == null
          ? "09:00"
          : instance.collectionCheckAt,
    };
