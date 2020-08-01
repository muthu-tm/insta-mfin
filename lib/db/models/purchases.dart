import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/plans.dart';
import 'package:json_annotation/json_annotation.dart';

part 'purchases.g.dart';

@JsonSerializable()
class Purchases extends Model {
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'user_number', nullable: true)
  int userID;
  @JsonKey(name: 'guid', nullable: true)
  String guid;
  @JsonKey(name: 'is_success', nullable: true)
  bool isSuccess;
  @JsonKey(name: 'status', nullable: true)
  int status;
  @JsonKey(name: 'payment_id', nullable: true)
  String paymentID;
  @JsonKey(name: 'plans', nullable: true)
  List<Plans> plans;
  @JsonKey(name: 'notes', nullable: true)
  String notes;
  @JsonKey(name: 'total_paid', nullable: true)
  int totalPaid;
  @JsonKey(name: 'total_amount', nullable: true)
  int totalAmount;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Purchases();

  factory Purchases.fromJson(Map<String, dynamic> json) =>
      _$PurchasesFromJson(json);
  Map<String, dynamic> toJson() => _$PurchasesToJson(this);

  CollectionReference getCollectionRef() {
    return Model.db.collection('purchases');
  }

  Future<QuerySnapshot> getSecKey() {
    return Model.db
        .collection("rz_key")
        .where('env', isEqualTo: "PROD")
        .getDocuments();
  }

  Future<String> create(List<Plans> plans, int tAmount) async {
    try {
      this.plans = plans;
      this.financeID = user.primary.financeID;
      this.userID = user.mobileNumber;
      this.guid = user.guid;
      this.isSuccess = false;
      this.paymentID = "";
      this.status = 0;
      this.totalPaid = 0;
      this.totalAmount = tAmount;
      this.notes = "Plans checkedout";
      this.createdAt = DateTime.now();
      this.updatedAt = DateTime.now();

      DocumentReference docRef = getCollectionRef().document();
      await docRef.setData(this.toJson());
      return docRef.documentID;
    } catch (err) {
      return "";
    }
  }

  Future updateError(String docID, String msg, int code) async {
    try {
      Map<String, dynamic> data = {
        "is_success": false,
        "status": code,
        "notes": msg,
        "updated_at": DateTime.now()
      };

      await getCollectionRef().document(docID).updateData(data);
    } catch (err) {
      return null;
    }
  }
}
