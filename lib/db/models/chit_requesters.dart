import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_requesters.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitRequesters {
  @JsonKey(name: 'customer_number')
  int custNumber;
  @JsonKey(name: 'chit_number')
  int chitNumber;
  @JsonKey(name: 'requested_at')
  int requestedAt;
  @JsonKey(name: 'notes')
  String notes;
  @JsonKey(name: 'is_allocated')
  bool isAllocated;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  ChitRequesters();

  factory ChitRequesters.fromJson(Map<String, dynamic> json) =>
      _$ChitRequestersFromJson(json);
  Map<String, dynamic> toJson() => _$ChitRequestersToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, int id) {
    return ChitFund()
        .getDocumentReference(financeId, branchName, subBranchName, id)
        .collection("chit_requesters");
  }

  String getDocumentID(DateTime createdAt) {
    return createdAt.millisecondsSinceEpoch.toString();
  }

  Future<void> create(String financeId, String branchName, String subBranchName,
      int chitID) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    try {
      await getCollectionRef(financeId, branchName, subBranchName, chitID)
          .document(getDocumentID(this.createdAt))
          .setData(this.toJson());
    } catch (err) {
      print('Chit Requesters CREATE failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamRequesters(String financeId, String branchName,
      String subBranchName, int chitID) {
    try {
      return getCollectionRef(financeId, branchName, subBranchName, chitID)
          .snapshots();
    } catch (err) {
      throw err;
    }
  }

  Future<void> update(String financeId, String branchName, String subBranchName,
      int chitID, DateTime createdAt, Map<String, dynamic> data) async {
    try {
      await getCollectionRef(financeId, branchName, subBranchName, chitID)
          .document(getDocumentID(createdAt))
          .updateData(data);
    } catch (err) {
      print('Chit Requesters Update failure:' + err.toString());
      throw err;
    }
  }

  Future<void> remove(String financeId, String branchName, String subBranchName,
      int chitID, DateTime createdAt) async {
    try {
      await getCollectionRef(financeId, branchName, subBranchName, chitID)
          .document(getDocumentID(createdAt))
          .delete();
    } catch (err) {
      print('Chit Requesters DELETE failure:' + err.toString());
      throw err;
    }
  }
}
