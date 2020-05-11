// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'miscellaneous_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MiscellaneousExpense _$MiscellaneousExpenseFromJson(Map<String, dynamic> json) {
  return MiscellaneousExpense()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..expenseName = json['expense_name'] as String
    ..category = json['category'] == null
        ? null
        : MiscellaneousCategory.fromJson(
            json['category'] as Map<String, dynamic>)
    ..amount = json['amount'] as int
    ..addedBy = json['added_by'] as int
    ..notes = json['notes'] as String ?? ''
    ..expenseDate = json['expense_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['expense_date'] as Timestamp))
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

Map<String, dynamic> _$MiscellaneousExpenseToJson(
        MiscellaneousExpense instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'expense_name': instance.expenseName,
      'category': instance.category?.toJson(),
      'expense_date': instance.expenseDate,
      'amount': instance.amount,
      'added_by': instance.addedBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
