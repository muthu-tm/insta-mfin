import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable()
class Address {
  
  @JsonKey(name: 'street', nullable: false)
  String street;
  @JsonKey(name: 'city', nullable: true)
  String city;
  @JsonKey(name: 'state', nullable: false)
  String state;
  @JsonKey(name: 'country', defaultValue: 'India')
  String country;
  @JsonKey(name: 'pincode', nullable: false)
  int pincode;

  Address(this.street, this.city, this.state, this.pincode);

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}