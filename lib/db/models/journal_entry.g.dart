// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return JournalEntry()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..journalName = json['journal_name'] as String
    ..category = json['category'] == null
        ? null
        : JournalCategory.fromJson(json['category'] as Map<String, dynamic>)
    ..amount = json['amount'] as int
    ..isExpense = json['is_expense'] as bool ?? false
    ..addedBy = json['added_by'] as int
    ..notes = json['notes'] as String ?? ''
    ..journalDate = json['journal_date'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['journal_date'] as Timestamp))
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

Map<String, dynamic> _$JournalEntryToJson(JournalEntry instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'journal_name': instance.journalName,
      'category': instance.category?.toJson(),
      'amount': instance.amount,
      'journal_date': instance.journalDate,
      'is_expense': instance.isExpense,
      'added_by': instance.addedBy,
      'notes': instance.notes == null ? '' : instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
