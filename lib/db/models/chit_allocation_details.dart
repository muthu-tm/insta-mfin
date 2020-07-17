import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_allocation_details.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitAllocationDetails {
  @JsonKey(name: 'given_on')
  int givenOn;
  @JsonKey(name: 'amount')
  int amount;
  @JsonKey(name: 'transferred_mode', nullable: true)
  int transferredMode;
  @JsonKey(name: 'given_to', defaultValue: '')
  String givenTo;
  @JsonKey(name: 'given_by', defaultValue: '')
  String givenBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;

  ChitAllocationDetails();

  factory ChitAllocationDetails.fromJson(Map<String, dynamic> json) =>
      _$ChitAllocationDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ChitAllocationDetailsToJson(this);
}
