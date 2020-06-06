import 'package:json_annotation/json_annotation.dart';

part 'user_preferences.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPreferences {
  
  @JsonKey(name: 'payment_group_by', defaultValue: 0)
  int paymentGroupBy;
  @JsonKey(name: 'transaction_group_by', defaultValue: 0)
  int transactionGroupBy;
  @JsonKey(name: 'enable_table_view', defaultValue: false)
  bool tableView;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences();

}