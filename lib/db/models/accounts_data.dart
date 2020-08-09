import 'package:json_annotation/json_annotation.dart';
part 'accounts_data.g.dart';

@JsonSerializable()
class AccountsData {
  @JsonKey(name: 'cash_in_hand', defaultValue: 0)
  int cashInHand;
  @JsonKey(name: 'total_doc_charge', defaultValue: 0)
  int totalDocCharge;
  @JsonKey(name: 'doc_charge', defaultValue: 0)
  int docCharge;
  @JsonKey(name: 'total_surcharge', defaultValue: 0)
  int totalSurCharge;
  @JsonKey(name: 'surcharge', defaultValue: 0)
  int surcharge;
  @JsonKey(name: 'total_payments', defaultValue: 0)
  int totalPayments;
  @JsonKey(name: 'payments_amount', defaultValue: 0)
  int paymentsAmount;
  @JsonKey(name: 'interest_amount', defaultValue: 0)
  int interestAmount;
  @JsonKey(name: 'collections_amount', defaultValue: 0)
  int collectionsAmount;

  AccountsData();

  factory AccountsData.fromJson(Map<String, dynamic> json) =>
      _$AccountsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AccountsDataToJson(this);
}
