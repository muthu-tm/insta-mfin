import 'package:json_annotation/json_annotation.dart';

part 'chit_fund_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitFundDetails {
  @JsonKey(name: 'chit_number')
  int chitNumber;
  @JsonKey(name: 'chit_date')
  int chitDate;
  @JsonKey(name: 'allocation_amount')
  int allocationAmount;
  @JsonKey(name: 'chit_amount')
  int chitAmount;
  @JsonKey(name: 'profit')
  int profit;

  ChitFundDetails();

  factory ChitFundDetails.fromJson(Map<String, dynamic> json) =>
      _$ChitFundDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ChitFundDetailsToJson(this);
}
