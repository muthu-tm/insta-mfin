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

  setCollectionDate(int collectionDate) {
    this.collectionDate = collectionDate;
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

  DocumentReference getPenaltyDocumentReference(
      String financeId,
      String branchName,
      String subBranchName,
      int number,
      DateTime createdAt,
      int collectionDate) {
    return getCollectionRef(
            financeId, branchName, subBranchName, number, createdAt)
        .document(getDocumentID(collectionDate + 4));
  }

  Future<Collection> create(DateTime createdAt, bool cAlready,
      CollectionDetails collDetails) async {
    this.createdAt = DateTime.now();
    this.financeID = this.financeID;
    this.branchName = this.branchName;
    this.subBranchName = this.subBranchName;

    String docID = "";
    if (this.type != 0) {
      docID = getDocumentID(this.collectionDate + this.type);
    } else {
      docID = getDocumentID(this.collectionDate);
    }

    if (!cAlready) {
      await getCollectionRef(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, createdAt)
          .document(docID)
          .setData(this.toJson());
    }

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
        if (doc.data['type'] != 1 &&
            doc.data['type'] != 2 &&
            doc.data['type'] != 4)
          collections.add(Collection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Stream<QuerySnapshot> streamCollectionsForPayment(String financeId,
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
      Map<String, dynamic> data,
      bool hasPenalty) async {
    Map<String, dynamic> fields = Map();

    DocumentReference docRef = this.getDocumentReference(financeId, branchName,
        subBranchName, number, createdAt, collectionDate);

    Map<String, dynamic> _coll = (await docRef.get()).data;
    List<dynamic> colls = _coll['collections'];
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

                if (hasPenalty) {
                  Collection _c = Collection.fromJson(_coll);
                  accData.cashInHand += data['penalty_amount'];
                  accData.penaltyAmount += data['penalty_amount'];

                  Map<String, dynamic> pData = {
                    "finance_id": _c.financeID,
                    "branch_name": _c.branchName,
                    "sub_branch_name": _c.subBranchName,
                    "collection_amount": data['penalty_amount'],
                    "customer_number": _c.customerNumber,
                    "collected_on": [data['collected_on']],
                    "collection_date": data['collected_on'],
                    "type": 4, // Penalty
                    "collections": [
                      {
                        "collected_on": data['collected_on'],
                        "is_paid_late": false,
                        "amount": data['penalty_amount'],
                        "transferred_mode": data['transferred_mode'],
                        "status": 1, // Paid
                        "collected_from": data['collected_from'],
                        "collected_by": data['collected_by'],
                        "notes": data['notes'],
                        "added_by": data['added_by'],
                        "created_at": data['created_at'],
                      }
                    ],
                    "collection_number": _c.collectionNumber,
                    "created_at": data['created_at'],
                  };
                  Model().txCreate(
                      tx,
                      this.getPenaltyDocumentReference(
                          financeId,
                          branchName,
                          subBranchName,
                          number,
                          createdAt,
                          data['collected_on']),
                      pData);
                }
              } else {
                accData.cashInHand -= data['amount'];
                accData.collectionsAmount -= data['amount'];
                if (hasPenalty) {
                  accData.cashInHand -= data['penalty_amount'];
                  accData.penaltyAmount -= data['penalty_amount'];

                  Model().txDelete(
                      tx,
                      this.getPenaltyDocumentReference(
                          financeId,
                          branchName,
                          subBranchName,
                          number,
                          createdAt,
                          data['collected_on']));
                }
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
