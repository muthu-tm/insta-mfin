import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/chit_allocation_details.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_allocations.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitAllocations {
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'chit_id', nullable: true)
  String chitID;
  @JsonKey(name: 'chit_number', nullable: true)
  int chitNumber;
  @JsonKey(name: 'customer', nullable: true)
  int customer;
  @JsonKey(name: 'allocations')
  List<ChitAllocationDetails> allocations;
  @JsonKey(name: 'is_paid', defaultValue: false)
  bool isPaid;
  @JsonKey(name: 'profit_amount', defaultValue: 0)
  int profitAmount;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  ChitAllocations();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory ChitAllocations.fromJson(Map<String, dynamic> json) =>
      _$ChitAllocationsFromJson(json);
  Map<String, dynamic> toJson() => _$ChitAllocationsToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, String chitID) {
    return ChitFund()
        .getDocumentReference(financeId, branchName, subBranchName, chitID)
        .collection("chit_allocations");
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('chit_allocations');
  }

  String getDocumentID(int chitNumber) {
    return chitNumber.toString();
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, String chitID, int chitNumber) {
    return getCollectionRef(financeId, branchName, subBranchName, chitID)
        .document(getDocumentID(chitNumber));
  }

  Future createTemplate(int number) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    try {} catch (err) {
      print('Chit Publish failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamChitAllocations(String financeID,
      String branchName, String subBranchName, String chitID) {
    return getCollectionRef(financeID, branchName, subBranchName, chitID)
        .snapshots();
  }

  Future removeChitAllocation(String financeID, String branchName,
      String subBranchName, String chitID, int chitNumber) async {
    DocumentReference docRef = getDocumentReference(
        financeID, branchName, subBranchName, chitID, chitNumber);

    try {
      await docRef.delete();
    } catch (err) {
      print('Chit Allocation DELETE failure:' + err.toString());
      throw err;
    }
  }
}
