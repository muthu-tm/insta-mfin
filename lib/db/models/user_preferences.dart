import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable()
class UserPreferences {
  
  @JsonKey(name: 'payment_group_by', defaultValue: 0)
  int paymentGroupBy;
  @JsonKey(name: 'transaction_group_by', defaultValue: 0)
  int transactionGroupBy;
  @JsonKey(name: 'collection_notification_at', defaultValue: '09:00')
  String collectionNotificationAt;
  @JsonKey(name: 'collection_check_at', defaultValue: '09:00')
  String collectionCheckAt;

  setPaymentGroupBy(int paymentBy) {
    this.paymentGroupBy = paymentBy;
  }
  
  setTransactionGroupBy(int transactionBy) {
    this.transactionGroupBy = transactionBy;
  }

  setCollectionNotificationAt(String notificationAt) {
    this.collectionNotificationAt = notificationAt;
  }
  
  setCollectionCheckAt(String collectionCheckAt) {
    this.collectionCheckAt = collectionCheckAt;
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences();

}