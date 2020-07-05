import 'package:json_annotation/json_annotation.dart';

part 'user_primary.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPrimary {
  
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;

  factory UserPrimary.fromJson(Map<String, dynamic> json) => _$UserPrimaryFromJson(json);
  Map<String, dynamic> toJson() => _$UserPrimaryToJson(this);

  UserPrimary();

}