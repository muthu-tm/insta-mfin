// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return Branch()
    ..branchName = json['branch_name'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..emails = (json['emails'] as List)?.map((e) => e as String)?.toList()
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..users = (json['users'] as List)?.map((e) => e as int)?.toList()
    ..displayProfilePath = json['display_profile_path'] as String
    ..dateOfRegistration = json['date_of_registration'] as String
    ..addedBy = json['added_by'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : json['created_at'] as DateTime
    ..updatedAt = json['updated_at'] == null
        ? null
        : json['updated_at'] as DateTime;
}

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'branch_name': instance.branchName,
      'address': instance.address?.toJson(),
      'emails': instance.emails,
      'admins': instance.admins,
      'users': instance.users,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'date_of_registration': instance.dateOfRegistration,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
