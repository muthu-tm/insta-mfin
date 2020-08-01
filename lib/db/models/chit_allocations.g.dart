part of 'chit_allocations.dart';

ChitAllocations _$ChitAllocationsFromJson(Map<String, dynamic> json) {
  return ChitAllocations()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..chitID = json['chit_id'] as int
    ..chitOriginalID = json['chit_org_id'] as String ?? ""
    ..chitNumber = json['chit_number'] as int
    ..customer = json['customer'] as int
    ..allocations = (json['allocations'] as List)
        ?.map((e) => e == null
            ? null
            : ChitAllocationDetails.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..isPaid = json['is_paid'] as bool ?? false
    ..allocationAmount = json['allocation_amount'] as int ?? 0
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

Map<String, dynamic> _$ChitAllocationsToJson(ChitAllocations instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'chit_id': instance.chitID,
      'chit_org_id': instance.chitOriginalID ?? "",
      'chit_number': instance.chitNumber,
      'customer': instance.customer,
      'allocations': instance.allocations?.map((e) => e?.toJson())?.toList(),
      'is_paid': instance.isPaid,
      'allocation_amount': instance.allocationAmount,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
