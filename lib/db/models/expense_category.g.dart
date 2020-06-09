part of 'expense_category.dart';

ExpenseCategory _$ExpenseCategoryFromJson(
    Map<String, dynamic> json) {
  return ExpenseCategory()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..categoryName = json['category_name'] as String
    ..addedBy = json['added_by'] as int
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

Map<String, dynamic> _$ExpenseCategoryToJson(
        ExpenseCategory instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'category_name': instance.categoryName,
      'added_by': instance.addedBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
