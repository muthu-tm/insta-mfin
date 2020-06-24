import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/enums/collection_type.dart';
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
  @JsonKey(name: 'payment_id', nullable: true)
  String paymentID;
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
  @JsonKey(name: 'is_paid', nullable: true)
  bool isPaid;
  @JsonKey(name: 'is_settled', nullable: true)
  bool isSettled;
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

  setPaymentID(String paymentID) {
    this.paymentID = paymentID;
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

  setIsPaid(bool isPaid) {
    this.isPaid = isPaid;
  }

  setIsSettled(bool isSettled) {
    this.isSettled = isSettled;
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
    if (this.type == 1 || this.type == 2 || this.type == 4) return 1;
    if (this.type == 5) return 5; // COMMISSION

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
      String subBranchName, String paymentID) {
    return Payment()
        .getDocumentReference(financeId, branchName, subBranchName, paymentID)
        .collection("customer_collections");
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('customer_collections');
  }

  String getDocumentID(int collectionDate) {
    return collectionDate.toString();
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, String paymentID, int collectionDate) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .document(getDocumentID(collectionDate));
  }

  DocumentReference getPenaltyDocumentReference(
      String financeId,
      String branchName,
      String subBranchName,
      String paymentID,
      int collectionDate) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .document(getDocumentID(collectionDate + 4));
  }

  Future<void> create(bool cAlready, Map<String, dynamic> collDetails) async {
    this.createdAt = DateTime.now();
    this.isSettled = false;

    String docID = "";
    if (this.type != 0) {
      docID = getDocumentID(this.collectionDate + this.type);
    } else {
      docID = getDocumentID(this.collectionDate);
    }

    if (!cAlready) {
      await getCollectionRef(this.financeID, this.branchName,
              this.subBranchName, this.paymentID)
          .document(docID)
          .setData(this.toJson());
    } else {
      DocumentReference docRef = getCollectionRef(this.financeID,
              this.branchName, this.subBranchName, this.paymentID)
          .document(docID);

      try {
        DocumentReference finDocRef = Payment().user.getFinanceDocReference();

        await Model.db.runTransaction(
          (tx) {
            return tx.get(finDocRef).then(
              (doc) async {
                AccountsData accData =
                    AccountsData.fromJson(doc.data['accounts_data']);

                accData.cashInHand += collDetails['amount'];
                if (this.type == CollectionType.Collection.name) {
                  accData.collectionsAmount += collDetails['amount'];
                } else if (this.type == CollectionType.Penalty.name) {
                  this.isPaid = true;

                  accData.totalPenalty += 1;
                  accData.penaltyAmount += collDetails['amount'];
                } else if (this.type == CollectionType.DocCharge.name) {
                  this.isPaid = true;

                  accData.totalDocCharge += 1;
                  accData.docCharge += collDetails['amount'];
                } else if (this.type == CollectionType.Surcharge.name) {
                  this.isPaid = true;

                  accData.totalSurCharge += 1;
                  accData.surcharge += collDetails['amount'];
                }

                if (collDetails['penalty_amount'] > 0) {
                  accData.cashInHand += collDetails['penalty_amount'];
                  accData.totalPenalty += 1;
                  accData.penaltyAmount += collDetails['penalty_amount'];

                  Map<String, dynamic> pData = {
                    "finance_id": this.financeID,
                    "branch_name": this.branchName,
                    "sub_branch_name": this.subBranchName,
                    "collection_amount": collDetails['penalty_amount'],
                    "is_paid": true,
                    "is_settled": false,
                    "customer_number": this.customerNumber,
                    "payment_id": this.paymentID,
                    "collected_on": [collDetails['collected_on']],
                    "collection_date": collDetails['collected_on'],
                    "type": 4, // Penalty
                    "collections": [
                      {
                        "collected_on": collDetails['collected_on'],
                        "is_paid_late": false,
                        "amount": collDetails['penalty_amount'],
                        "transferred_mode": collDetails['transferred_mode'],
                        "status": 1, // Paid
                        "collected_from": collDetails['collected_from'],
                        "collected_by": collDetails['collected_by'],
                        "notes": collDetails['notes'],
                        "added_by": collDetails['added_by'],
                        "created_at": DateTime.now(),
                      }
                    ],
                    "collection_number": this.collectionNumber,
                    "created_at": DateTime.now(),
                  };
                  Model().txCreate(
                      tx,
                      this.getPenaltyDocumentReference(
                          this.financeID,
                          this.branchName,
                          this.subBranchName,
                          this.paymentID,
                          collDetails['collected_on']),
                      pData);
                }

                Map<String, dynamic> aData = {
                  'accounts_data': accData.toJson()
                };
                Model().txUpdate(tx, finDocRef, aData);

                CollectionDetails cDetails =
                    CollectionDetails.fromJson(collDetails);
                cDetails.createdAt = DateTime.now();
                this.collections = [cDetails];

                Model().txCreate(tx, docRef, this.toJson());
              },
            );
          },
        );
      } catch (err) {
        print('Collection CREATE Transaction failure:' + err.toString());
        throw err;
      }
    }
  }

  Stream<QuerySnapshot> streamCollectionsForCustomer(String financeId,
      String branchName, String subBranchName, String paymentID) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .snapshots();
  }

  Future<List<Collection>> getAllPendingCollectionByDate(String financeId,
      String branchName, String subBranchName, int epoch) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collection_date', isLessThanOrEqualTo: epoch)
        .where('type', isEqualTo: 0)
        .where('is_settled', isEqualTo: false)
        .where('is_paid', isEqualTo: false)
        .getDocuments();

    List<Collection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(Collection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<Collection>> getAllCollectionByDate(
      String financeId,
      String branchName,
      String subBranchName,
      List<int> types,
      bool isSettled,
      int epoch) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collection_date', isEqualTo: epoch)
        .where('type', whereIn: types)
        .where('is_settled', isEqualTo: isSettled)
        .getDocuments();

    List<Collection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(Collection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<Collection>> allCollectionByDate(
      String financeId,
      String branchName,
      String subBranchName,
      List<int> types,
      int epoch) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collection_date', isEqualTo: epoch)
        .where('type', whereIn: types)
        .getDocuments();

    List<Collection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(Collection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<Collection>> getAllCollectionsByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      List<int> types,
      int start,
      int end) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collection_date', isGreaterThanOrEqualTo: start)
        .where('collection_date', isLessThanOrEqualTo: end)
        .where('type', whereIn: types)
        .getDocuments();

    List<Collection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(Collection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<Collection>> getAllCollectionDetailsByDateRange(String financeId,
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
      String branchName, String subBranchName, String paymentID) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .snapshots();
  }

  Stream<QuerySnapshot> streamUpcomingForPayment(String financeId,
      String branchName, String subBranchName, String paymentID) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .where('collection_date',
            isGreaterThan: DateUtils.getUTCDateEpoch(DateTime.now()))
        .snapshots();
  }

  Stream<QuerySnapshot> streamTodaysForPayment(String financeId,
      String branchName, String subBranchName, String paymentID) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .where('collection_date',
            isEqualTo: DateUtils.getUTCDateEpoch(DateTime.now()))
        .where('type', isEqualTo: 0)
        .snapshots();
  }

  Stream<QuerySnapshot> streamPastForPayment(String financeId,
      String branchName, String subBranchName, String paymentID) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .where('collection_date',
            isLessThan: DateUtils.getUTCDateEpoch(DateTime.now()))
        .snapshots();
  }

  Future<Collection> getByCollectionNumber(String financeID, String branchName,
      String subBranchName, String paymentID, int cNumber) async {
    var collectionDocs =
        await getCollectionRef(financeID, branchName, subBranchName, paymentID)
            .where('collection_number', isEqualTo: cNumber)
            .where('type', isEqualTo: CollectionType.Collection.name)
            .getDocuments();

    Collection coll;
    if (collectionDocs.documents.isNotEmpty) {
      coll = Collection.fromJson(collectionDocs.documents[0].data);
      return coll;
    } else {
      return null;
    }
  }

  Future<List<Collection>> getByCollectionType(
      String financeID,
      String branchName,
      String subBranchName,
      String paymentID,
      int type) async {
    var collectionDocs =
        await getCollectionRef(financeID, branchName, subBranchName, paymentID)
            .where('type', isEqualTo: type)
            .getDocuments();

    List<Collection> colls = [];
    if (collectionDocs.documents.isNotEmpty) {
      collectionDocs.documents.forEach((c) {
        colls.add(Collection.fromJson(c.data));
      });
    }

    return colls;
  }

  Future<List<Collection>> getAllCollectionsForCustomerPayment(String financeId,
      String branchName, String subBranchName, String paymentID) async {
    var collectionDocs =
        await getCollectionRef(financeId, branchName, subBranchName, paymentID)
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

  Future<Collection> getCollectionByID(String financeId, String branchName,
      String subBranchName, String paymentID, String docID) async {
    DocumentSnapshot snapshot =
        await getCollectionRef(financeId, branchName, subBranchName, paymentID)
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
      String paymentID,
      int collectionDate) {
    return getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .document(getDocumentID(collectionDate))
        .snapshots();
  }

  Future<void> update(String financeId, String branchName, String subBranchName,
      String paymentID, String docID, Map<String, dynamic> collJSON) async {
    collJSON['updated_at'] = DateTime.now();

    await getCollectionRef(financeId, branchName, subBranchName, paymentID)
        .document(docID)
        .updateData(collJSON);
  }

  Future updateCollectionDetails(
      String financeId,
      String branchName,
      String subBranchName,
      String paymentID,
      int collectionDate,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> data,
      bool hasPenalty) async {
    Map<String, dynamic> fields = Map();

    DocumentReference docRef = this.getDocumentReference(
        financeId, branchName, subBranchName, paymentID, collectionDate);

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

    fields['is_paid'] = isPaid;

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
                  accData.totalPenalty += 1;
                  accData.penaltyAmount += data['penalty_amount'];

                  Map<String, dynamic> pData = {
                    "finance_id": _c.financeID,
                    "branch_name": _c.branchName,
                    "sub_branch_name": _c.subBranchName,
                    "collection_amount": data['penalty_amount'],
                    "is_paid": true,
                    "is_settled": false,
                    "customer_number": _c.customerNumber,
                    "payment_id": _c.paymentID,
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
                      this.getPenaltyDocumentReference(financeId, branchName,
                          subBranchName, paymentID, data['collected_on']),
                      pData);
                }
              } else {
                accData.cashInHand -= data['amount'];
                accData.collectionsAmount -= data['amount'];
                if (hasPenalty) {
                  accData.cashInHand -= data['penalty_amount'];
                  accData.totalPenalty -= 1;
                  accData.penaltyAmount -= data['penalty_amount'];

                  Model().txDelete(
                      tx,
                      this.getPenaltyDocumentReference(financeId, branchName,
                          subBranchName, paymentID, data['collected_on']));
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
