// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Finance _$FinanceFromJson(Map<String, dynamic> json) {
  return Finance()
    ..registrationID = json['registration_id'] as String
    ..financeName = json['finance_name'] as String
    ..emails = (json['emails'] as List)?.map((e) => e as String)?.toList()
    ..admins = (json['admins'] as List)?.map((e) => e as int)?.toList()
    ..users = (json['users'] as List)?.map((e) => e as int)?.toList()
    ..displayProfilePath = json['display_profile_path'] as String
    ..address = json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>)
    ..dateOfRegistration = json['date_of_registration'] as String
    ..allocatedBranchCount = json['allocated_branch_count'] as int
    ..availableBranchCount = json['available_branch_count'] as int
    ..allocatedUsersCount = json['allocated_users_count'] as int
    ..availableUsersCount = json['available_users_count'] as int
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

Map<String, dynamic> _$FinanceToJson(Finance instance) => <String, dynamic>{
      'registration_id': instance.registrationID,
      'finance_name': instance.financeName,
      'emails': instance.emails,
      'admins': instance.admins,
      'users': instance.users,
      'display_profile_path': instance.displayProfilePath == null
          ? ''
          : instance.displayProfilePath,
      'address': instance.address?.toJson(),
      'date_of_registration': instance.dateOfRegistration,
      'allocated_branch_count': instance.allocatedBranchCount,
      'available_branch_count': instance.availableBranchCount,
      'allocated_users_count': instance.allocatedUsersCount,
      'available_users_count': instance.availableUsersCount,
      'added_by': instance.addedBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
