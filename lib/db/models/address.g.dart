// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
    ..street = json['street'] as String ?? ''
    ..city = json['city'] as String ?? ''
    ..state = json['state'] as String ?? ''
    ..pincode = json['pincode'] as String ?? 00
    ..country = json['country'] as String ?? 'India';
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street == null ? '' : instance.street,
      'city': instance.city == null ? '' : instance.city,
      'state': instance.state == null ? '' : instance.state,
      'country': instance.country == null ? 'India' : instance.country,
      'pincode': instance.pincode == null ? '' : instance.pincode,
    };
