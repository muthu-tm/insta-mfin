import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'collection.g.dart';

@JsonSerializable(explicitToJson: true)
class Collection {
  Payment payment = Payment();

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'customer_number', nullable: true)
  int customerNumber;
  @JsonKey(name: 'collection_number', nullable: true)
  int collectionNumber;
  @JsonKey(name: 'collection_date', defaultValue: '')
  DateTime collectionDate;
  @JsonKey(name: 'collection_amount')
  int collectionAmount;
  @JsonKey(name: 'collections')
  List<CollectionDetails> collections;
  @JsonKey(name: 'total_paid', defaultValue: 0)
  int totalPaid;
  @JsonKey(name: 'status', defaultValue: 0)
  int status;
  @JsonKey(name: 'type', nullable: true)
  int type;
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

  setCustomerNumber(int number) {
    this.customerNumber = number;
  }

  setcollectionNumber(int number) {
    this.collectionNumber = number;
  }

  setCollectionDate(DateTime collectionDate) {
    this.collectionDate = collectionDate;
  }

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
  }

  setTotalPaid(int paid) {
    this.totalPaid = paid;
  }

  setStatus(int status) {
    this.status = status;
  }

  setType(int type) {
    this.type = type;
  }

  addCollections(List<CollectionDetails> collections) {
    if (this.collections == null) {
      this.collections = collections;
    } else {
      this.collections.addAll(collections);
    }
  }

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) {
    return payment
        .getDocumentReference(
            financeId, branchName, subBranchName, number, createdAt)
        .collection("customer_collections");
  }

  User getUser() {
    return payment.user;
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('customer_collections');
  }

  String getDocumentID(DateTime collectionDate) {
    return collectionDate.millisecondsSinceEpoch.toString();
  }

  DocumentReference getDocumentReference(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      DateTime collectionDate) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(getDocumentID(collectionDate));
  }

  Future<Collection> create(int number, DateTime createdAt) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = getUser().primaryFinance;
    this.branchName = getUser().primaryBranch;
    this.subBranchName = getUser().primarySubBranch;

    await getDocumentReference(this.financeID, this.branchName,
            this.subBranchName, number, createdAt, this.collectionDate)
        .setData(this.toJson());

    return this;
  }

  Future<bool> isExist(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      DateTime collectionDate) async {
    var snap = await getDocumentReference(financeId, branchName, subBranchName,
            number, createdAt, collectionDate)
        .get();

    return snap.exists;
  }

  Stream<QuerySnapshot> streamCollectionsForCustomer(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .snapshots();
  }

  Stream<QuerySnapshot> streamCollections(String financeId, String branchName,
      String subBranchName, List<int> status) {
    return getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('status', whereIn: status)
        .snapshots();
  }

  Stream<QuerySnapshot> streamCollectionsByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      List<int> status,
      bool fetchAll) {
    if (fetchAll) {
      return getCollectionRef(
              financeId, branchName, subBranchName, number, createdAt)
          .snapshots();
    } else {
      return getCollectionRef(
              financeId, branchName, subBranchName, number, createdAt)
          .where('status', whereIn: status)
          .snapshots();
    }
  }

  Future<List<Collection>> getAllCollectionsForCustomer(String financeId,
      String branchName, String subBranchName, int custNumber) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('customer_number', isEqualTo: custNumber)
        .getDocuments();

    List<Collection> coll = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        coll.add(Collection.fromJson(doc.data));
      }
    }

    return coll;
  }

  Future<List<Collection>> getAllCollectionsForCustomerPayment(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt) async {
    var collectionDocs = await getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .getDocuments();

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

  Future<List<Collection>> getAllCollectionsByStatus(String financeId,
      String branchName, String subBranchName, int status) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('status', isEqualTo: status)
        .getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Future<List<Collection>> getAllCollectionsForCustomerByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      int status) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('customer_number', isEqualTo: custNumber)
        .where('status', isEqualTo: status)
        .getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Future<List<Collection>> getAllCollectionsForPaymentByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int custNumber,
      DateTime createdAt,
      int status) async {
    var collectionDocs = await getCollectionRef(
            financeId, branchName, subBranchName, custNumber, createdAt)
        .where('status', isEqualTo: status)
        .getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Future<Collection> getCollectionByID(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      String docID) async {
    DocumentSnapshot snapshot = await getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(docID)
        .get();

    if (snapshot.exists) {
      return Collection.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future<void> update(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      String docID,
      Map<String, dynamic> paymentJSON) async {
    paymentJSON['updated_at'] = DateTime.now();

    await getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(docID)
        .updateData(paymentJSON);
  }

  Future updateArrayField(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      DateTime collectionDate,
      bool isAdd,
      Map<String, dynamic> data) async {
    Map<String, dynamic> fields = Map();
    fields['updated_at'] = DateTime.now();

    data.forEach((key, value) {
      if (isAdd) {
        fields[key] = FieldValue.arrayUnion(value);
      } else {
        fields[key] = FieldValue.arrayRemove(value);
      }
    });

    await this
        .getDocumentReference(financeId, branchName, subBranchName, number,
            createdAt, collectionDate)
        .updateData(fields);
    return data;
  }
}
