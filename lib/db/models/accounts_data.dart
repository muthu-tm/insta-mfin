import 'package:json_annotation/json_annotation.dart';
part 'accounts_data.g.dart';

@JsonSerializable()
class AccountsData {
  @JsonKey(name: 'cash_in_hand', defaultValue: 0)
  int cashInHand;
  @JsonKey(name: 'journal_in', defaultValue: 0)
  int journalIn;
  @JsonKey(name: 'journal_in_amount', defaultValue: 0)
  int journalInAmount;
  @JsonKey(name: 'journal_out', defaultValue: 0)
  int journalOut;
  @JsonKey(name: 'journal_out_amount', defaultValue: 0)
  int journalOutAmount;
  @JsonKey(name: 'expense', defaultValue: 0)
  int expense;
  @JsonKey(name: 'expense_amount', defaultValue: 0)
  int expenseAmount;
  @JsonKey(name: 'total_payments', defaultValue: 0)
  int totalPayments;
  @JsonKey(name: 'payments_amount', defaultValue: 0)
  int paymentsAmount;
  @JsonKey(name: 'collections_amount', defaultValue: 0)
  int collectionsAmount;
  @JsonKey(name: 'penality_amount', defaultValue: 0)
  int penalityAmount;

  AccountsData();

  factory AccountsData.fromJson(Map<String, dynamic> json) =>
      _$AccountsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AccountsDataToJson(this);
}
