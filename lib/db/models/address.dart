import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable()
class Address {
  
  @JsonKey(name: 'street', defaultValue: '')
  String street;
  @JsonKey(name: 'city', defaultValue: '')
  String city;
  @JsonKey(name: 'state', defaultValue: '')
  String state;
  @JsonKey(name: 'country', defaultValue: 'India')
  String country;
  @JsonKey(name: 'pincode', defaultValue: 00)
  int pincode;

  Address();

  setStreet(String street) {
    this.street = street;
  }

  setCity(String city) {
    this.city = city;
  }

  setState(String state) {
    this.state = state;
  }

  setPinCode(int pincode) {
    this.pincode = pincode;
  }

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}