part of 'chit_fund.dart';

ChitFund _$ChitFundFromJson(Map<String, dynamic> json) {
  return ChitFund()
    ..chitName = json['name'] as String
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..chitID = json['chit_id'] as String
    ..id = json['id'] as int
    ..customerDetails = (json['customer_details'] as List)
        ?.map((e) => e == null
            ? null
            : ChitCustomers.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..customers = (json['customers'] as List)?.map((e) => e as int)?.toList()
    ..datePublished = json['date_published'] as int
    ..chitAmount = json['chit_amount'] as int
    ..tenure = json['tenure'] as int
    ..fundDetails = (json['fund_details'] as List)
        ?.map((e) => e == null
            ? null
            : ChitFundDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..alreadyCompletedMonths = json['already_completed_months'] as int
    ..interestRate = (json['interest_rate'] as num)?.toDouble()
    ..collectionDate = json['collection_date'] as int
    ..closedDate = json['closed_date'] as int
    ..isClosed = json['is_closed'] as bool ?? false
    ..profitAmount = json['profit_amount'] as int ?? 0
    ..notes = json['notes'] as String ?? ''
    ..publishedBy = json['published_by'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$ChitFundToJson(ChitFund instance) => <String, dynamic>{
      'name': instance.chitName,
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'chit_id': instance.chitID,
      'id': instance.id,
      'customer_details':
          instance.customerDetails?.map((e) => e?.toJson())?.toList(),
      'customers': instance.customers,
      'date_published': instance.datePublished,
      'chit_amount': instance.chitAmount,
      'fund_details': instance.fundDetails?.map((e) => e?.toJson())?.toList(),
      'tenure': instance.tenure,
      'already_completed_months': instance.alreadyCompletedMonths,
      'interest_rate': instance.interestRate,
      'collection_date': instance.collectionDate,
      'closed_date': instance.closedDate,
      'is_closed': instance.isClosed,
      'profit_amount': instance.profitAmount,
      'notes': instance.notes,
      'published_by': instance.publishedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
