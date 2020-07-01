import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:instamfin/db/models/subscription_data.dart';

part 'subscriptions.g.dart';

@JsonSerializable(explicitToJson: true)
class Subscriptions extends Model {
  static CollectionReference _subscriptionCollRef =
      Model.db.collection("subscriptions");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'chit', nullable: true)
  SubscriptionData chit;
  @JsonKey(name: 'service', nullable: true)
  SubscriptionData service;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Subscriptions();

  factory Subscriptions.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionsToJson(this);

  CollectionReference getCollectionRef() {
    return _subscriptionCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;

    return HashGenerator.hmacGenerator(value, this.financeID);
  }

  User getUser() {
    return super.user;
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('customer_payments');
  }

  String getDocumentID(
      String financeID, String branchName, String subBranchName) {
    String value = financeID + branchName + subBranchName;
    return HashGenerator.hmacGenerator(value, financeID);
  }

  DocumentReference getDocumentReference(
      String financeID, String branchName, String subBranchName) {
    return getCollectionRef()
        .document(getDocumentID(financeID, branchName, subBranchName));
  }

  Future<bool> isExist() async {
    var subSnap = await getDocumentReference(
            this.financeID, this.branchName, this.subBranchName)
        .get();

    return subSnap.exists;
  }

  Future createTemplate() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await super.add(this.toJson());
  }

  Future<Subscriptions> getSubscriptions(
      String financeID, String branchName, String subBranchName) async {
    try {
      String docID = getDocumentID(financeID, branchName, subBranchName);
      Map<String, dynamic> data = await super.getByID(docID);

      if (data != null) {
        return Subscriptions.fromJson(data);
      } else {
        throw 'No Subscriptions for this account!';
      }
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }
}
