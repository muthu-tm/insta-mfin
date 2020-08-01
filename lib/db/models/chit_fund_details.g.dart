part of 'chit_fund_details.dart';

ChitFundDetails _$ChitFundDetailsFromJson(Map<String, dynamic> json) {
  return ChitFundDetails()
    ..chitNumber = json['chit_number'] as int ?? 0
    ..chitDate = json['chit_date'] as int ?? 0
    ..totalAmount = json['total_amount'] as int ?? 0
    ..allocationAmount = json['allocation_amount'] as int ?? 0
    ..collectionAmount = json['collection_amount'] as int ?? 0
    ..profit = json['profit'] as int ?? 0;
}

Map<String, dynamic> _$ChitFundDetailsToJson(ChitFundDetails instance) =>
    <String, dynamic>{
      'chit_number': instance.chitNumber ?? 0,
      'chit_date': instance.chitDate ?? 0,
      'total_amount': instance.totalAmount ?? 0,
      'allocation_amount': instance.allocationAmount ?? 0,
      'collection_amount': instance.collectionAmount ?? 0,
      'profit': instance.profit ?? 0,
    };
