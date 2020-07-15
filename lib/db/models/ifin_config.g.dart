part of 'ifin_config.dart';

IfinConfig _$IfinConfigFromJson(Map<String, dynamic> json) {
  return IfinConfig()
    ..cVersion = json['current_version'] as String
    ..minVersion = json['min_version'] as String
    ..platform = json['platform'] as String
    ..appURL = json['app_url'] as String
    ..rechargeEnabled = json['recharge_enabled'] as bool ?? true
    ..payEnabled = json['payment_enabled'] as bool ?? true;
}

Map<String, dynamic> _$IfinConfigToJson(IfinConfig instance) =>
    <String, dynamic>{
      'current_version': instance.cVersion,
      'min_version': instance.minVersion,
      'platform': instance.platform,
      'app_url': instance.appURL,
      'recharge_enabled': instance.rechargeEnabled,
      'payment_enabled': instance.payEnabled,
    };
