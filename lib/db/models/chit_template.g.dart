part of 'chit_template.dart';

ChitTemplate _$ChitTemplateFromJson(Map<String, dynamic> json) {
  return ChitTemplate()
    ..name = json['template_name'] as String
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..chitAmount = json['chit_amount'] as int
    ..tenure = json['tenure'] as int
    ..collectionDay = json['collection_day'] as int
    ..fundDetails = (json['fund_details'] as List)
        ?.map((e) => e == null
            ? null
            : ChitFundDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..notes = json['notes'] as String ?? ''
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

Map<String, dynamic> _$ChitTemplateToJson(ChitTemplate instance) =>
    <String, dynamic>{
      'template_name': instance.name,
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'chit_amount': instance.chitAmount,
      'tenure': instance.tenure,
      'collection_day': instance.collectionDay,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
