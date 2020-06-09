import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
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
  int collectionDate;
  @JsonKey(name: 'notify_at', defaultValue: '')
  int notifyAt;
  @JsonKey(name: 'collected_on', defaultValue: '')
  List<int> collectedOn;
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
    this.collectionDate = DateUtils.getUTCDateEpoch(collectionDate);
  }

  setNotifyAt(DateTime notifyAt) {
    this.notifyAt = DateUtils.getUTCDateEpoch(notifyAt);
  }

  setcollectedOn(List<int> collectedOn) {
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

  int getReceived() {
    int received = 0;
    if (this.collections != null) {
      this.collections.forEach((coll) {
        received += coll.amount;
      });
    }

    return received;
  }

  int getPaidLate() {
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

  int getPaidOnTime() {
    int paid = 0;
    if (this.collections != null) {
      this.collections.forEach((coll) {
        if (!coll.isPaidLate) {
          paid += coll.amount;
        }
      });
    }

    return paid;
  }

  int getPending() {
    if (this.collectionDate <
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getCurrent() {
    if (this.collectionDate ==
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getUpcoming() {
    if (this.collectionDate >
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getStatus() {
    if (this.type == 1 || this.type == 2) return 1;

    if (getPaidOnTime() > 0 && getPending() == 0) return 1;

    if (this.collectionDate <
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      if (getPending() == 0 && getPaidLate() == 0)
        return 1; //PAID
      else if (getPending() == 0 && getPaidLate() >= 0)
        return 2; //PAIDLATE
      else
        return 4; //PENDING
    } else if (this.collectionDate >
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return 0; //UPCOMING
    } else {
      return 3; //CURRENT
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

  String getDocumentID(int collectionDate) {
    return collectionDate.toString();
  }

  DocumentReference getDocumentReference(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      int collectionDate) {
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

  Stream<QuerySnapshot> streamCollectionsForCustomer(String financeId,
      String branchName, String subBranchName, int number, DateTime createdAt) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .snapshots();
  }

  Future<List<Collection>> getAllCollectionsByDateRange(String financeId,
      String branchName, String subBranchName, List<int> dates) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collected_on', arrayContainsAny: dates)
        .getDocuments();

    List<Collection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        if (doc.data['type'] != 1 && doc.data['type'] != 2)
          collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Stream<QuerySnapshot> streamCollectionsByStatus(String financeId,
      String branchName, String subBranchName, int number, DateTime createdAt) {
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
      int collectionDate) {
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
      int collectionDate,
      bool isAdd,
      Map<String, dynamic> data) async {
    Map<String, dynamic> fields = Map();

    DocumentReference docRef = this.getDocumentReference(financeId, branchName,
        subBranchName, number, createdAt, collectionDate);

    List<dynamic> colls = (await docRef.get()).data['collections'];
    int index = 0;
    bool isMatched = false;
    if (colls != null) {
      for (index = 0; index < colls.length; index++) {
        Map<String, dynamic> collDetail = colls[index];
        CollectionDetails collDetails = CollectionDetails.fromJson(collDetail);
        if (collDetails.collectedOn == data['collected_on']) {
          isMatched = true;
          break;
        }
      }
    }

    if (isAdd) {
      if (isMatched) {
        throw 'Found a Collection on this date. Edit that one, Please!';
      } else {
        fields['updated_at'] = DateTime.now();
        fields['collected_on'] = FieldValue.arrayUnion([data['collected_on']]);
        fields['collections'] = FieldValue.arrayUnion([data]);
      }
    } else {
      if (isMatched) colls.removeAt(index);
      fields['collections'] = colls;
      fields['collected_on'] = FieldValue.arrayRemove([data['collected_on']]);
      fields['updated_at'] = DateTime.now();
    }

    try {
      DocumentReference finDocRef = Payment().user.getFinanceDocReference();

      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              if (isAdd) {
                accData.cashInHand += data['amount'];
                accData.collectionsAmount += data['amount'];
              } else {
                accData.cashInHand -= data['amount'];
                accData.collectionsAmount -= data['amount'];
              }

              Map<String, dynamic> aData = {'accounts_data': accData.toJson()};
              Model().txUpdate(tx, finDocRef, aData);
              Model().txUpdate(tx, docRef, fields);
            },
          );
        },
      );
    } catch (err) {
      print('Collection ADD/REMOVE Transaction failure:' + err.toString());
      throw err;
    }

    return data;
  }
}
