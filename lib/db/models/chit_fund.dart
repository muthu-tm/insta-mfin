import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/chit_collection.dart';
import 'package:instamfin/db/models/chit_customers.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_fund.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitFund extends Model {
  static CollectionReference _chitCollRef = Model.db.collection("chit_funds");

  @JsonKey(name: 'name', nullable: true)
  String chitName;
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'chit_id', nullable: true)
  String chitID;
  @JsonKey(name: 'id', nullable: true)
  int id;
  @JsonKey(name: 'customers_details', nullable: true)
  List<ChitCustomers> customerDetails;
  @JsonKey(name: 'customers', nullable: true)
  List<int> customers;
  @JsonKey(name: 'date_published', nullable: true)
  int datePublished;
  @JsonKey(name: 'chit_amount', nullable: true)
  int chitAmount;
  @JsonKey(name: 'tenure', nullable: true)
  int tenure;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_date', nullable: true)
  int collectionDate;
  @JsonKey(name: 'fund_details')
  List<ChitFundDetails> fundDetails;
  @JsonKey(name: 'closed_date', nullable: true)
  int closedDate;
  @JsonKey(name: 'is_closed', defaultValue: false)
  bool isClosed;
  @JsonKey(name: 'profit_amount', defaultValue: 0)
  int profitAmount;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'published_by', nullable: true)
  int publishedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  ChitFund();

  setChitName(String name) {
    this.chitName = name;
  }

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setChitID(String chitID) {
    this.chitID = chitID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setchitAmount(int amount) {
    this.chitAmount = amount;
  }

  setTenure(int tenure) {
    this.tenure = tenure;
  }

  setFundDetails(List<ChitFundDetails> fundDetails) {
    this.fundDetails = fundDetails;
  }

  setCustomers(List<int> customers) {
    this.customers = customers;
  }

  setInterestRate(double iRate) {
    this.interestRate = iRate;
  }

  setPublishedBy(int publishedBy) {
    this.publishedBy = publishedBy;
  }

  setDatePublished(int date) {
    this.datePublished = date;
  }

  setCollectionDate(int date) {
    this.collectionDate = date;
  }

  setIsClosed(bool isClosed) {
    this.isClosed = isClosed;
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

  factory ChitFund.fromJson(Map<String, dynamic> json) =>
      _$ChitFundFromJson(json);
  Map<String, dynamic> toJson() => _$ChitFundToJson(this);

  CollectionReference getCollectionRef() {
    return _chitCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;

    return HashGenerator.hmacGenerator(value, this.id.toString());
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('chit_funds');
  }

  String getDocumentID(
      String financeId, String branchName, String subBranchName, int id) {
    String value = financeId + branchName + subBranchName;
    return HashGenerator.hmacGenerator(value, id.toString());
  }

  DocumentReference getDocumentReference(
      String financeId, String branchName, String subBranchName, int id) {
    return getCollectionRef()
        .document(getDocumentID(financeId, branchName, subBranchName, id));
  }

  Future create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primary.financeID;
    this.branchName = user.primary.branchName;
    this.subBranchName = user.primary.subBranchName;
    this.publishedBy = user.mobileNumber;
    this.id = createdAt.millisecondsSinceEpoch;
    try {
      await super.add(this.toJson());
    } catch (err) {
      print('Chit Publish failure:' + err.toString());
      throw err;
    }
  }

  Future<ChitFund> getByChitID(int chitID) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('id', isEqualTo: chitID)
        .getDocuments();

    if (snap.documents.isNotEmpty)
      return ChitFund.fromJson(snap.documents.first.data);

    return null;
  }

  Future<List<ChitFund>> getByCustNumber(String financeID, String branchName,
      String subBranchName, int custNumber) async {
    if (custNumber == null) {
      return [];
    }

    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: financeID)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('customers', arrayContains: custNumber)
        .getDocuments();

    List<ChitFund> chitList = [];
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((chit) {
        chitList.add(ChitFund.fromJson(chit.data));
      });
    }

    return chitList;
  }

  Stream<QuerySnapshot> streamChits() {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .orderBy('date_published', descending: true)
        .snapshots();
  }

  Future<List<ChitFund>> getAllChitsForCustomer(int number) async {
    if (number == null) {
      return [];
    }

    var chitDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('customers', arrayContains: number)
        .getDocuments();

    List<ChitFund> chits = [];
    if (chitDocs.documents.isNotEmpty) {
      for (var doc in chitDocs.documents) {
        chits.add(ChitFund.fromJson(doc.data));
      }
    }

    return chits;
  }

  Stream<QuerySnapshot> streamAllByStatus(bool isClosed) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('is_closed', isEqualTo: isClosed)
        .snapshots();
  }

  Future<bool> isChitReceived(int chitID) async {
    try {
      ChitFund chit = await getByChitID(chitID);

      if (chit == null) {
        throw 'No ChitFund found for this chitID $chitID';
      }

      bool received = false;
      for (int i = 0; i < chit.tenure; i++) {
        if (received) break;

        List<ChitCollection> colls = await ChitCollection()
            .getByCollectionNumber(chit.financeID, chit.branchName,
                chit.subBranchName, chit.id, i + 1);

        for (int index = 0; index < colls.length; index++) {
          if (colls[index].getReceived() > 0) {
            received = true;
            break;
          }
        }
      }

      return received;
    } catch (err) {
      throw err;
    }
  }

  Future removeChit(int id) async {
    DocumentReference docRef = getDocumentReference(user.primary.financeID,
        user.primary.branchName, user.primary.subBranchName, id);

    try {
      QuerySnapshot snapshot =
          await docRef.collection("chit_requesters").getDocuments();

      for (int i = 0; i < snapshot.documents.length; i++) {
        await snapshot.documents[i].reference.delete();
      }

      snapshot = await docRef.collection("chit_allocations").getDocuments();

      for (int i = 0; i < snapshot.documents.length; i++) {
        await snapshot.documents[i].reference.delete();
      }

      snapshot = await docRef.collection("chits").getDocuments();

      for (int i = 0; i < snapshot.documents.length; i++) {
        QuerySnapshot snap = await snapshot.documents[i].reference
            .collection("chit_collections")
            .getDocuments();
        for (int i = 0; i < snap.documents.length; i++) {
          await snap.documents[i].reference.delete();
        }

        await snapshot.documents[i].reference.delete();
      }

      await docRef.delete();
    } catch (err) {
      print('Chit Fund DELETE failure:' + err.toString());
      throw err;
    }
  }
}
