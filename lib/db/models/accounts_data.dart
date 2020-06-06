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
  @JsonKey(name: 'miscellaneous_expense', defaultValue: 0)
  int miscellaneousExpense;
  @JsonKey(name: 'miscellaneous_expense_amount', defaultValue: 0)
  int miscellaneousExpenseAmount;
  @JsonKey(name: 'total_payments', defaultValue: 0)
  int totalPayments;
  @JsonKey(name: 'payments_amount', defaultValue: 0)
  int paymentsAmount;
  @JsonKey(name: 'total_collections', defaultValue: 0)
  int totalCollections;
  @JsonKey(name: 'collections_amount', defaultValue: 0)
  int collectiosAmount;
  @JsonKey(name: 'pending_collections', defaultValue: 0)
  int pendingCollectios;
  @JsonKey(name: 'pending_collections_amount', defaultValue: 0)
  int pendingCollectiosAmount;
  @JsonKey(name: 'upcoming_collections', defaultValue: 0)
  int upcomingCollectios;
  @JsonKey(name: 'upcoming_collections_amount', defaultValue: 0)
  int upcomingCollectiosAmount;

  AccountsData();

  factory AccountsData.fromJson(Map<String, dynamic> json) =>
      _$AccountsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AccountsDataToJson(this);
}
