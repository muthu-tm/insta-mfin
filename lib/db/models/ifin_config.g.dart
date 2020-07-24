part of 'ifin_config.dart';

IfinConfig _$IfinConfigFromJson(Map<String, dynamic> json) {
  return IfinConfig()
    ..cVersion = json['current_version'] as String
    ..minVersion = json['min_version'] as String
    ..platform = json['platform'] as String
    ..appURL = json['app_url'] as String
    ..referralBonus = json['referral_bonus'] as int
    ..registrationBonus = json['registration_bonus'] as int
    ..rechargeEnabled = json['recharge_enabled'] as bool ?? true
    ..payEnabled = json['payment_enabled'] as bool ?? true;
}

Map<String, dynamic> _$IfinConfigToJson(IfinConfig instance) =>
    <String, dynamic>{
      'current_version': instance.cVersion,
      'min_version': instance.minVersion,
      'platform': instance.platform,
      'app_url': instance.appURL,
      'referral_bonus': instance.referralBonus,
      'registration_bonus': instance.registrationBonus,
      'recharge_enabled': instance.rechargeEnabled,
      'payment_enabled': instance.payEnabled,
    };
