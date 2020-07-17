part of 'chit_fund.dart';

ChitFund _$ChitFundFromJson(Map<String, dynamic> json) {
  return ChitFund()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..chitID = json['chit_id'] as String
    ..customerNumbers =
        (json['customers'] as List)?.map((e) => e as int)?.toList()
    ..requesters = (json['requesters'] as List)?.map((e) => e as int)?.toList()
    ..datePublished = json['date_publishes'] as int
    ..chitAmount = json['chit_amount'] as int
    ..tenure = json['tenure'] as int
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
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'chit_id': instance.chitID,
      'customers': instance.customerNumbers,
      'requesters': instance.requesters,
      'date_publishes': instance.datePublished,
      'chit_amount': instance.chitAmount,
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
