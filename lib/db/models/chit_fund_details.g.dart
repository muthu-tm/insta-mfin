part of 'chit_fund_details.dart';

ChitFundDetails _$ChitFundDetailsFromJson(
    Map<String, dynamic> json) {
  return ChitFundDetails()
    ..chitNumber = json['chit_number'] as int
    ..totalAmount = json['total_amount'] as int
    ..allocationAmount = json['allocation_amount'] as int
    ..collectionAmount = json['collection_amount'] as int
    ..profit = json['profit'] as int;
}

Map<String, dynamic> _$ChitFundDetailsToJson(
        ChitFundDetails instance) =>
    <String, dynamic>{
      'chit_number': instance.chitNumber,
      'total_amount': instance.totalAmount,
      'allocation_amount': instance.allocationAmount,
      'collection_amount': instance.collectionAmount,
      'profit': instance.profit,
    };
