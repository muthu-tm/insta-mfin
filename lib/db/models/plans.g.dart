part of 'plans.dart';

Plans _$PlansFromJson(Map<String, dynamic> json) {
  return Plans()
    ..smsCredits = json['allowed_sms_credits'] as int ?? 0
    ..inr = json['inr'] as int ?? 0
    ..notes = json['notes'] as String ?? ''
    ..moreInfo = json['more_info'] as String ?? ''
    ..planID = json['plan_id'] as int ?? 0
    ..name = json['plan_name'] as String ?? 0
    ..type = json['plan_type'] as String ?? 0
    ..validFor = json['valid_for'] as int ?? 0;
}

Map<String, dynamic> _$PlansToJson(Plans instance) => <String, dynamic>{
      'allowed_sms_credits': instance.smsCredits,
      'inr': instance.inr,
      'notes': instance.notes,
      'more_info': instance.moreInfo,
      'plan_id': instance.planID,
      'plan_name': instance.name,
      'plan_type': instance.type,
      'valid_for': instance.validFor,
    };
