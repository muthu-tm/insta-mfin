part of 'chit_fund_details.dart';

ChitFundDetails _$ChitFundDetailsFromJson(Map<String, dynamic> json) {
  return ChitFundDetails()
    ..chitNumber = json['chit_number'] as int
    ..chitDate = json['chit_date'] as int
    ..allocationAmount = json['allocation_amount'] as int
    ..chitAmount = json['chit_amount'] as int
    ..profit = json['profit'] as int;
}

Map<String, dynamic> _$ChitFundDetailsToJson(ChitFundDetails instance) =>
    <String, dynamic>{
      'chit_number': instance.chitNumber,
      'chit_date': instance.chitDate,
      'allocation_amount': instance.allocationAmount,
      'chit_amount': instance.chitAmount,
      'profit': instance.profit,
    };
