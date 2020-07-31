import 'package:json_annotation/json_annotation.dart';
part 'account_preferences.g.dart';

@JsonSerializable()
class AccountPreferences {
  @JsonKey(name: 'report_signature', nullable: true)
  String reportSignature;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_mode', nullable: true)
  int collectionMode;
  @JsonKey(name: 'interest_from_principal', nullable: true)
  bool interestFromPrincipal;
  @JsonKey(name: 'chit_enabled', nullable: true)
  bool chitEnabled;
  @JsonKey(name: 'collection_days', nullable: true)
  List<int> collectionDays;

  factory AccountPreferences.fromJson(Map<String, dynamic> json) =>
      _$AccountPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$AccountPreferencesToJson(this);

  AccountPreferences();
}
