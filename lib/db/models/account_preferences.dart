import 'package:json_annotation/json_annotation.dart';
part 'account_preferences.g.dart';

@JsonSerializable()
class AccountPreferences {
  
  @JsonKey(name: 'report_signature', nullable: true)
  String reportSignature;

  factory AccountPreferences.fromJson(Map<String, dynamic> json) => _$AccountPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$AccountPreferencesToJson(this);

  AccountPreferences();
}