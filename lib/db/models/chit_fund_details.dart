import 'package:json_annotation/json_annotation.dart';

part 'chit_fund_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitFundDetails {
  @JsonKey(name: 'chit_number')
  int chitNumber;
  @JsonKey(name: 'total_amount')
  int totalAmount;
  @JsonKey(name: 'allocation_amount')
  int allocationAmount;
  @JsonKey(name: 'collection_amount')
  int collectionAmount;
  @JsonKey(name: 'profit')
  int profit;

  ChitFundDetails();

  factory ChitFundDetails.fromJson(Map<String, dynamic> json) =>
      _$ChitFundDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ChitFundDetailsToJson(this);
}
