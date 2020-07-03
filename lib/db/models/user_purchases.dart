import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_purchases.g.dart';

@JsonSerializable()
class UserPurchases extends Model {
  static CollectionReference _purchasesCollRef =
      Model.db.collection("user_purchases");

  @JsonKey(name: 'plans')
  List<Plans> plans;
  @JsonKey(name: 'total_paid', defaultValue: 0)
  int totalPaid;
  @JsonKey(name: 'purchased_by', defaultValue: 0)
  int purchasedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  UserPurchases();

  factory UserPurchases.fromJson(Map<String, dynamic> json) =>
      _$UserPurchasesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPurchasesToJson(this);

  CollectionReference getCollectionRef() {
    return _purchasesCollRef;
  }
}
