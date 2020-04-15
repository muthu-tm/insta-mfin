// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubBranch _$SubBranchFromJson(Map<String, dynamic> json) {
  return SubBranch()
    ..subBranchName = json['sub_branch_name'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..emails = (json['emails'] as List)?.map((e) => e as String)?.toList()
    ..admins = (json['admins'] as List)?.map((e) => e as String)?.toList()
    ..displayProfilePath = json['display_profile_path'] as String
    ..dateOfRegistration = json['date_of_registration'] as String
    ..addedBy = json['added_by'] as int
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

Map<String, dynamic> _$SubBranchToJson(SubBranch instance) => <String, dynamic>{
      'sub_branch_name': instance.subBranchName,
      'address': instance.address?.toJson(),
      'emails': instance.emails,
      'admins': instance.admins,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'date_of_registration': instance.dateOfRegistration,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
