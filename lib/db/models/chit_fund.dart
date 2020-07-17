import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_fund.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitFund extends Model {
  static CollectionReference _chitCollRef = Model.db.collection("chit_fund");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'chit_id', nullable: true)
  String chitID;
  @JsonKey(name: 'customers', nullable: true)
  List<int> customerNumbers;
  @JsonKey(name: 'requesters', nullable: true)
  List<int> requesters;
  @JsonKey(name: 'date_publishes', nullable: true)
  int datePublished;
  @JsonKey(name: 'chit_amount', nullable: true)
  int chitAmount;
  @JsonKey(name: 'tenure', nullable: true)
  int tenure;
  @JsonKey(name: 'already_completed_months', nullable: true)
  int alreadyCompletedMonths;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_date', nullable: true)
  int collectionDate;
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

    return HashGenerator.hmacGenerator(value, this.chitID);
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('chit_fund');
  }

  String getDocumentID(String financeId, String branchName,
      String subBranchName, String chitID) {
    String value = financeId + branchName + subBranchName;
    return HashGenerator.hmacGenerator(value, chitID);
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, String chitID) {
    return getCollectionRef()
        .document(getDocumentID(financeId, branchName, subBranchName, chitID));
  }

  Future<bool> isExist() async {
    var chitSnap = await getDocumentReference(
            this.financeID, this.branchName, this.subBranchName, this.chitID)
        .get();

    return chitSnap.exists;
  }

  Future create(int number) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primary.financeID;
    this.branchName = user.primary.branchName;
    this.subBranchName = user.primary.subBranchName;
    try {
      bool isExist = await this.isExist();

      if (isExist) {
        throw 'Already a Payment exist with this PAYMENT ID - ${this.chitID}';
      } else {}
    } catch (err) {
      print('Chit Publish failure:' + err.toString());
      throw err;
    }
  }

  Future<List<Map<String, dynamic>>> getByChitID(String financeID,
      String branchName, String subBranchName, String chitID) async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: financeID)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_id', isEqualTo: chitID)
        .getDocuments();

    List<Map<String, dynamic>> chitList = [];
    if (snap.documents.isNotEmpty) {
      snap.documents.forEach((chit) {
        chitList.add(chit.data);
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

  Future removeChit(String financeId, String branchName, String subBranchName,
      String chitID) async {
    DocumentReference docRef =
        getDocumentReference(financeId, branchName, subBranchName, chitID);

    try {
      QuerySnapshot snapshot =
          await docRef.collection('chit_collections').getDocuments();

      for (int i = 0; i < snapshot.documents.length; i++) {
        await snapshot.documents[i].reference.delete();
      }
    } catch (err) {
      print('Chit Fund DELETE failure:' + err.toString());
      throw err;
    }
  }
}
