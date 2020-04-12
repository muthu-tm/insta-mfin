// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company()
    ..financeID = json['finance_id'] as String
    ..registrationID = json['registration_id'] as String
    ..financeName = json['finance_name'] as String
    ..branches = (json['braches'] as List)?.map((e) => e as String)?.toList()
    ..admins = (json['admins'] as List)?.map((e) => e as String)?.toList()
    ..displayProfilePath = json['display_profile_path'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..dateOfRegistration = json['date_of_registration'] as String
    ..allocatedBranchCount = json['allocated_branch_count'] as int
    ..availableBranchCount = json['available_branch_count'] as int
    ..allocatedUsersCount = json['allocated_users_count'] as int
    ..availableUsersCount = json['available_users_count'] as int
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(json['created_at'] as Timestamp))
    ..updatedAt = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(_getMillisecondsSinceEpoch(json['updated_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'finance_id': instance.financeID,
      'registration_id': instance.registrationID,
      'finance_name': instance.financeName,
      'braches': instance.branches,
      'admins': instance.admins,
      'display_profile_path': instance.displayProfilePath,
      'address': instance.address?.toJson(),
      'date_of_registration': instance.dateOfRegistration,
      'allocated_branch_count': instance.allocatedBranchCount,
      'available_branch_count': instance.availableBranchCount,
      'allocated_users_count': instance.allocatedUsersCount,
      'available_users_count': instance.availableUsersCount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
