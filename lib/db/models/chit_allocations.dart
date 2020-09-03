import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/chit_allocation_details.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
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
  int chitID;
  @JsonKey(name: 'chit_org_id', nullable: true)
  String chitOriginalID;
  @JsonKey(name: 'chit_number', nullable: true)
  int chitNumber;
  @JsonKey(name: 'customer', nullable: true)
  int customer;
  @JsonKey(name: 'allocations')
  List<ChitAllocationDetails> allocations;
  @JsonKey(name: 'is_paid', defaultValue: false)
  bool isPaid;
  @JsonKey(name: 'allocation_amount', defaultValue: 0)
  int allocationAmount;
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

  setAllocationAmount(int amount) {
    this.allocationAmount = amount;
  }

  setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  int getTotalPaid() {
    int received = 0;
    if (this.allocations != null) {
      this.allocations.forEach((coll) {
        received += coll.amount;
      });
    }

    return received;
  }

  factory ChitAllocations.fromJson(Map<String, dynamic> json) =>
      _$ChitAllocationsFromJson(json);
  Map<String, dynamic> toJson() => _$ChitAllocationsToJson(this);

  CollectionReference getCollectionRef(
      String financeId, String branchName, String subBranchName, int chitID) {
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
      String subBranchName, int chitID, int chitNumber) {
    return getCollectionRef(financeId, branchName, subBranchName, chitID)
        .document(getDocumentID(chitNumber));
  }

  Future<ChitAllocations> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.allocations = this.allocations ?? [];
    try {
      await getDocumentReference(this.financeID, this.branchName,
              this.subBranchName, this.chitID, this.chitNumber)
          .setData(this.toJson());
      return this;
    } catch (err) {
      print('Chit Publish failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamChitAllocations(
      String financeID, String branchName, String subBranchName, int chitID) {
    return getCollectionRef(financeID, branchName, subBranchName, chitID)
        .snapshots();
  }

  Future<List<ChitAllocations>> getChitAllocations(String financeID,
      String branchName, String subBranchName, int chitID) async {
    QuerySnapshot snap =
        await getCollectionRef(financeID, branchName, subBranchName, chitID)
            .getDocuments();

    List<ChitAllocations> colls = [];
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((doc) {
        colls.add(ChitAllocations.fromJson(doc.data));
      });
    }

    return colls;
  }

  Future<ChitAllocations> getAllocationsByNumber(
      String financeID,
      String branchName,
      String subBranchName,
      int chitID,
      int chitNumber) async {
    DocumentSnapshot snap = await getDocumentReference(
            financeID, branchName, subBranchName, chitID, chitNumber)
        .get();

    if (!snap.exists)
      return null;
    else {
      return ChitAllocations.fromJson(snap.data);
    }
  }

  Stream<DocumentSnapshot> streamAllocationsByNumber(String financeID,
      String branchName, String subBranchName, int chitID, int chitNumber) {
    return getDocumentReference(
            financeID, branchName, subBranchName, chitID, chitNumber)
        .snapshots();
  }

  Future removeChitAllocation(String financeID, String branchName,
      String subBranchName, int chitID, int chitNumber) async {
    DocumentReference docRef = getDocumentReference(
        financeID, branchName, subBranchName, chitID, chitNumber);

    try {
      await docRef.delete();
    } catch (err) {
      print('Chit Allocation DELETE failure:' + err.toString());
      throw err;
    }
  }

  Future updateAllocationDetails(
      String financeId,
      String branchName,
      String subBranchName,
      int chitID,
      int chitNumer,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> data) async {
    Map<String, dynamic> fields = Map();

    DocumentReference docRef = this.getDocumentReference(
        financeId, branchName, subBranchName, chitID, chitNumer);

    Map<String, dynamic> _coll = (await docRef.get()).data;
    List<dynamic> colls = _coll['allocations'];
    int index = 0;
    bool isMatched = false;
    if (colls != null) {
      for (index = 0; index < colls.length; index++) {
        Map<String, dynamic> collDetail = colls[index];
        ChitAllocationDetails collDetails =
            ChitAllocationDetails.fromJson(collDetail);
        if (collDetails.givenOn == data['given_on']) {
          isMatched = true;
          break;
        }
      }
    }

    fields['is_paid'] = isPaid;

    if (isAdd) {
      if (isMatched) {
        throw 'Found a Allocation on this date. Edit that one, Please!';
      } else {
        fields['updated_at'] = DateTime.now();
        fields['given_on'] = FieldValue.arrayUnion([data['given_on']]);
        fields['allocations'] = FieldValue.arrayUnion([data]);
      }
    } else {
      if (isMatched) colls.removeAt(index);
      fields['allocations'] = colls;
      fields['given_on'] = FieldValue.arrayRemove([data['given_on']]);
      fields['updated_at'] = DateTime.now();
    }

    try {
      DocumentReference finDocRef = cachedLocalUser.getFinanceDocReference();

      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              if (isAdd) {
                accData.cashInHand -= data['amount'];
              } else {
                accData.cashInHand += data['amount'];
              }

              Map<String, dynamic> aData = {'accounts_data': accData.toJson()};
              Model().txUpdate(tx, finDocRef, aData);
              Model().txUpdate(tx, getDocumentReference(
        financeId, branchName, subBranchName, chitID, chitNumer), fields);
            },
          );
        },
      );
    } catch (err) {
      print('Allocation ADD/REMOVE Transaction failure:' + err.toString());
      throw err;
    }

    return data;
  }
}
