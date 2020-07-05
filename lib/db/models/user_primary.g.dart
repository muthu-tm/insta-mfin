part of 'user_primary.dart';

UserPrimary _$UserPrimaryFromJson(Map<String, dynamic> json) {
  return UserPrimary()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String;
}

Map<String, dynamic> _$UserPrimaryToJson(UserPrimary instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
    };
