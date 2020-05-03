import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'collection.g.dart';

@JsonSerializable()
class Collection {
  
  @JsonKey(name: 'date', defaultValue: '')
  String date;
  @JsonKey(name: 'amount')
  int amount;
  @JsonKey(name: 'status')
  int status;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Collection();

  setDate(String date) {
    this.date = date;
  }

  setAmount(int amount) {
    this.amount = amount;
  }

  setStatus(int status) {
    this.status = status;
  }

  factory Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

}