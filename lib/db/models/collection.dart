import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'collection.g.dart';

@JsonSerializable()
class Collection {
  Payment payment = Payment();

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'collection_date', defaultValue: '')
  DateTime collectionDate;
  @JsonKey(name: 'paid_date', defaultValue: '')
  DateTime paidDate;
  @JsonKey(name: 'is_paid_late', defaultValue: false)
  bool isPaidLate;
  @JsonKey(name: 'amount')
  int amount;
  @JsonKey(name: 'status', defaultValue: 0)
  int status;
  @JsonKey(name: 'paid_by', defaultValue: '')
  String paidBy;
  @JsonKey(name: 'paid_to', defaultValue: '')
  String paidTo;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Collection();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setCollectionDate(DateTime collectionDate) {
    this.collectionDate = collectionDate;
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

  setPaidTo(String paidTo) {
    this.paidTo = paidTo;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  CollectionReference getCollectionRef(int number, String paymentID) {
    return payment
        .getDocumentReference(number, paymentID)
        .collection("customer_collections");
  }

  User getUser() {
    return payment.getUser();
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('customer_collection');
  }

  String getDocumentID(DateTime collectionDate) {
    return collectionDate.millisecondsSinceEpoch.toString();
  }

  DocumentReference getDocumentReference(
      int number, String paymentID, DateTime collectionDate) {
    return getCollectionRef(number, paymentID)
        .document(getDocumentID(collectionDate));
  }

  Future<Collection> create(int number, String paymentID) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = getUser().primaryFinance;
    this.branchName = getUser().primaryBranch;
    this.subBranchName = getUser().primarySubBranch;

    await getDocumentReference(number, paymentID, this.collectionDate)
        .setData(this.toJson());

    return this;
  }

  Future<bool> isExist(
      int number, String paymentID, DateTime collectionDate) async {
    var snap =
        await getDocumentReference(number, paymentID, collectionDate).get();

    return snap.exists;
  }

  Stream<QuerySnapshot> streamCollections(int number, String paymentID) {
    return getCollectionRef(number, paymentID).snapshots();
  }

  Future<List<Collection>> getAllCollectionsForCustomerPayment(
      int number, String paymentID) async {
    var collectionDocs =
        await getCollectionRef(number, paymentID).getDocuments();

    List<Collection> coll = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        coll.add(Collection.fromJson(doc.data));
      }
    }

    return coll;
  }

  Future<List<Collection>> getAllCollections() async {
    var collectionDocs = await getGroupQuery().getDocuments();

    List<Collection> payments = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        payments.add(Collection.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<List<Collection>> getAllCollectionsByStatus(int status) async {
    var collectionDocs =
        await getGroupQuery().where('status', isEqualTo: status).getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Future<Collection> getCollectionByID(
      int number, String paymentID, String docID) async {
    DocumentSnapshot snapshot =
        await getCollectionRef(number, paymentID).document(docID).get();

    if (snapshot.exists) {
      return Collection.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future<void> update(int number, String paymentID, String docID,
      Map<String, dynamic> paymentJSON) async {
    paymentJSON['updated_at'] = DateTime.now();

    await getCollectionRef(number, paymentID)
        .document(docID)
        .updateData(paymentJSON);
  }
}
