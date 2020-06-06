// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification()
    ..financeID = json['finance_id'] as String
    ..branchName = json['branch_name'] as String
    ..subBranchName = json['sub_branch_name'] as String
    ..createdBy = json['created_by'] as int
    ..userNumber = json['user_number'] as int
    ..custNumber = json['cust_number'] as int
    ..type = json['type'] as int
    ..data = json['data'] as Map<String, dynamic>
    ..title = json['title'] as String
    ..desc = json['description'] as String
    ..logoPath = json['logo_path'] as String
    ..refPath = json['ref_path'] as String
    ..createdAt = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            _getMillisecondsSinceEpoch(json['created_at'] as Timestamp));
}

int _getMillisecondsSinceEpoch(Timestamp ts) {
  return ts.millisecondsSinceEpoch;
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'finance_id': instance.financeID,
      'branch_name': instance.branchName,
      'sub_branch_name': instance.subBranchName,
      'created_by': instance.createdBy,
      'user_number': instance.userNumber,
      'cust_number': instance.custNumber,
      'type': instance.type,
      'data': instance.data,
      'title': instance.title,
      'description': instance.desc,
      'logo_path': instance.logoPath,
      'ref_path': instance.refPath,
      'created_at': instance.createdAt,
    };
