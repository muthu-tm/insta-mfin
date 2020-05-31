import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/enums/collection_status.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/payment.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'collection.g.dart';

@JsonSerializable(explicitToJson: true)
class Collection {
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
  @JsonKey(name: 'notify_at', defaultValue: '')
  DateTime notifyAt;
  @JsonKey(name: 'collected_on', defaultValue: '')
  List<DateTime> collectedOn;
  @JsonKey(name: 'collection_amount')
  int collectionAmount;
  @JsonKey(name: 'collections')
  List<CollectionDetails> collections;
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

  setNotifyAt(DateTime notifyAt) {
    this.notifyAt = notifyAt;
  }

  setcollectedOn(List<DateTime> collectedOn) {
    if (this.collectedOn == null) {
      this.collectedOn = collectedOn;
    } else {
      this.collectedOn.addAll(collectedOn);
    }
  }

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
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

  int getAmountPaid() {
    int totalPaid = 0;
    if (this.collections != null) {
      this.collections.forEach((coll) {
        totalPaid += coll.amount;
      });
    }

    return totalPaid;
  }

  int getAmountPaidLate() {
    int paidLate = 0;
    if (this.collections != null) {
      this.collections.forEach((coll) {
        if (coll.isPaidLate) {
          paidLate += coll.amount;
        }
      });
    }

    return paidLate;
  }

  int getPendingAmount() {
    if (this.collectionDate.isBefore(DateUtils.getCurrentDate())) {
      return collectionAmount - getAmountPaid();
    }

    return 0;
  }

  int getCurrentAmount() {
    if (this.collectionDate.isAtSameMomentAs(DateUtils.getCurrentDate())) {
      return collectionAmount - getAmountPaid();
    }

    return 0;
  }

  int getUpcomingAmount() {
    if (this.collectionDate.isAfter(DateUtils.getCurrentDate())) {
      return collectionAmount - getAmountPaid();
    }

    return 0;
  }

  int getStatus() {
    if (this.collectionDate.isBefore(DateUtils.getCurrentDate())) {
      if (getPendingAmount() == 0 && getAmountPaidLate() == 0)
        return CollectionStatus.Paid.name;
      else if (getPendingAmount() == 0 && getAmountPaidLate() >= 0)
        return CollectionStatus.PaidLate.name;
      else
        return CollectionStatus.Pending.name;
    } else if (this.collectionDate.isAfter(DateUtils.getCurrentDate())) {
      return CollectionStatus.Upcoming.name;
    } else {
      return CollectionStatus.Current.name;
    }
  }

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) {
    return Payment()
        .getDocumentReference(
            financeId, branchName, subBranchName, number, createdAt)
        .collection("customer_collections");
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

  Future<Collection> create(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = financeId;
    this.branchName = branchName;
    this.subBranchName = subBranchName;

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

  Stream<QuerySnapshot> streamCollectionsForCustomer(String financeId,
      String branchName, String subBranchName, int number, DateTime createdAt) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .snapshots();
  }

  Future<List<Collection>> getAllCollectionsByDateRage(String financeId,
      String branchName, String subBranchName, List<DateTime> dates) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collected_on', arrayContainsAny: dates)
        .getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Stream<QuerySnapshot> streamCollectionsByStatus(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .snapshots();
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

  Stream<DocumentSnapshot> streamCollectionByID(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      DateTime collectionDate) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(getDocumentID(collectionDate))
        .snapshots();
  }

  Future<void> update(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      String docID,
      Map<String, dynamic> collJSON) async {
    collJSON['updated_at'] = DateTime.now();

    await getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(docID)
        .updateData(collJSON);
  }

  Future updateCollectionDetails(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      DateTime collectionDate,
      bool isAdd,
      Map<String, dynamic> data) async {
    Map<String, dynamic> fields = Map();

    if (isAdd) {
      fields['updated_at'] = DateTime.now();
      fields['collections'] = FieldValue.arrayUnion([data]);
      await this
          .getDocumentReference(financeId, branchName, subBranchName, number,
              createdAt, collectionDate)
          .updateData(fields);
    } else {
      DocumentSnapshot snap = await this
          .getDocumentReference(financeId, branchName, subBranchName, number,
              createdAt, collectionDate)
          .get();

      List<dynamic> colls = snap.data['collections'];
      int index = 0;
      for (index = 0; index < colls.length; index++) {
        Map<String, dynamic> collDetail = colls[index];
        CollectionDetails collDetails = CollectionDetails.fromJson(collDetail);
        if (collDetails.createdAt == data['created_at']) {
          break;
        }
      }

      colls.removeAt(index);
      fields['collections'] = colls;
      fields['updated_at'] = DateTime.now();
    }

    await this
        .getDocumentReference(financeId, branchName, subBranchName, number,
            createdAt, collectionDate)
        .updateData(fields);

    return data;
  }
}
