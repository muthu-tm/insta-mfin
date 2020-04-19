// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address()
  ..street = json['street'] as String
  ..city = json['city'] as String
  ..state = json['state'] as String
  ..pincode = json['pincode'] as int
  ..country = json['country'] as String ?? 'India';
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country == null ? 'India' : instance.country,
      'pincode': instance.pincode,
    };
