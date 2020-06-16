import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_details.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionDetails {

  @JsonKey(name: 'collected_on')
  int collectedOn;
  @JsonKey(name: 'is_paid_late', defaultValue: false)
  bool isPaidLate;
  @JsonKey(name: 'amount')
  int amount;
  @JsonKey(name: 'transferred_mode', nullable: true)
  int transferredMode;
  @JsonKey(name: 'collected_from', defaultValue: '')
  String collectedFrom;
  @JsonKey(name: 'collected_by', defaultValue: '')
  String collectedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;

  CollectionDetails();

  factory CollectionDetails.fromJson(Map<String, dynamic> json) =>
      _$CollectionDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionDetailsToJson(this);
}