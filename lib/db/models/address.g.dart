part of 'address.dart';

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..street = json['street'] as String ?? ''
    ..city = json['city'] as String ?? ''
    ..state = json['state'] as String ?? ''
    ..pincode = json['pincode'] as String ?? 00
    ..country = json['country'] as String ?? 'India';
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street ?? '',
      'city': instance.city ?? '',
      'state': instance.state ?? '',
      'country': instance.country ?? 'India',
      'pincode': instance.pincode ?? '',
    };
