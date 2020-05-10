import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_details.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionDetails {

  @JsonKey(name: 'paid_date')
  DateTime paidDate;
  @JsonKey(name: 'is_paid_late', defaultValue: false)
  bool isPaidLate;
  @JsonKey(name: 'amount')
  int amount;
  @JsonKey(name: 'status', defaultValue: 0)
  int status;
  @JsonKey(name: 'paid_by', defaultValue: '')
  String paidBy;
  @JsonKey(name: 'collected_by', defaultValue: '')
  String collectedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  CollectionDetails();

  setPaidDate(DateTime date) {
    this.paidDate = date;
  }

  setIsPaidLate(bool isPaidLate) {
    this.isPaidLate = isPaidLate;
  }

  setAmount(int amount) {
    this.amount = amount;
  }

  setStatus(int status) {
    this.status = status;
  }

  setPaidBy(String paidBy) {
    this.paidBy = paidBy;
  }

  setCollectedBy(String collectedBy) {
    this.collectedBy = collectedBy;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  setAddedBy(int addedBy) {
    this.addedBy = addedBy;
  }

  factory CollectionDetails.fromJson(Map<String, dynamic> json) =>
      _$CollectionDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionDetailsToJson(this);
}