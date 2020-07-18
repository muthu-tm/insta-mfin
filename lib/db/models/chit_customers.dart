import 'package:json_annotation/json_annotation.dart';

part 'chit_customers.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitCustomers {
  @JsonKey(name: 'customer_number', nullable: true)
  int number;
  @JsonKey(name: 'chits', nullable: true)
  int chits;

  ChitCustomers();

  factory ChitCustomers.fromJson(Map<String, dynamic> json) =>
      _$ChitCustomersFromJson(json);
  Map<String, dynamic> toJson() => _$ChitCustomersToJson(this);
}
