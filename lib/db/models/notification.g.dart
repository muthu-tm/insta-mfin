part of 'notification.dart';

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification()
    ..financeID = json['finance_id'] as String
    ..createdBy = json['created_by'] as String
    ..userNumber = json['user_number'] as int
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
      'created_by': instance.createdBy,
      'user_number': instance.userNumber,
      'type': instance.type,
      'data': instance.data,
      'title': instance.title,
      'description': instance.desc,
      'logo_path': instance.logoPath,
      'ref_path': instance.refPath,
      'created_at': instance.createdAt,
    };
