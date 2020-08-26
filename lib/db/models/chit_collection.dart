import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/chit_fund.dart';
import 'package:instamfin/db/models/collection_details.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chit_collection.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitCollection {
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'customer_number', nullable: true)
  int customerNumber;
  @JsonKey(name: 'chit_id', nullable: true)
  int chitID;
  @JsonKey(name: 'chit_org_id', nullable: true)
  String chitOriginalID;
  @JsonKey(name: 'chit_number', nullable: true)
  int chitNumber;
  @JsonKey(name: 'chit_date', defaultValue: '')
  int chitDate;
  @JsonKey(name: 'collected_on', defaultValue: '')
  List<int> collectedOn;
  @JsonKey(name: 'collection_amount')
  int collectionAmount;
  @JsonKey(name: 'collections')
  List<CollectionDetails> collections;
  @JsonKey(name: 'is_paid', nullable: true)
  bool isPaid;
  @JsonKey(name: 'is_closed', nullable: true)
  bool isClosed;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;

  ChitCollection();

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

  setChitID(int chitID) {
    this.chitID = chitID;
  }

  setchitNumber(int number) {
    this.chitNumber = number;
  }

  setChitDate(int chitDate) {
    this.chitDate = chitDate;
  }

  setcollectedOn(List<int> collectedOn) {
    if (this.collectedOn == null) {
      this.collectedOn = collectedOn;
    } else {
      this.collectedOn.addAll(collectedOn);
    }
  }

  setCollecitonAmount(int amount) {
    this.collectionAmount = amount;
  }

  setIsPaid(bool isPaid) {
    this.isPaid = isPaid;
  }

  setIsClosed(bool isClosed) {
    this.isClosed = isClosed;
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
    if (this.chitDate < DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getPenalty() {
    int penalty = 0;
    if (this.collections != null) {
      this.collections.forEach((coll) {
        penalty += coll.penaltyAmount;
      });
    }

    return penalty;
  }

  int getCurrent() {
    if (this.chitDate == DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getUpcoming() {
    if (this.chitDate > DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return collectionAmount - getReceived();
    }

    return 0;
  }

  int getStatus() {
    if (getPaidOnTime() > 0 && getPending() == 0) return 1;

    if (this.chitDate < DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      if (getPending() == 0 && getPaidLate() == 0)
        return 1; //PAID
      else if (getPending() == 0 && getPaidLate() >= 0)
        return 2; //PAIDLATE
      else
        return 4; //PENDING
    } else if (this.chitDate >
        DateUtils.getCurrentUTCDate().millisecondsSinceEpoch) {
      return 0; //UPCOMING
    } else {
      return 3; //CURRENT
    }
  }

  factory ChitCollection.fromJson(Map<String, dynamic> json) =>
      _$ChitCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$ChitCollectionToJson(this);

  CollectionReference getCollectionRef(String financeId, String branchName,
      String subBranchName, int chitID, int chitNumber) {
    return ChitFund()
        .getDocumentReference(financeId, branchName, subBranchName, chitID)
        .collection("chits")
        .document(chitNumber.toString())
        .collection("chit_collections");
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('chit_collections');
  }

  String getDocumentID(int mNumber) {
    return mNumber.toString();
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, int chitID, int mNumber, int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .document(getDocumentID(mNumber));
  }

  Stream<QuerySnapshot> streamAllPendingChitByDate(
      String financeId, String branchName, String subBranchName, int epoch) {
    return getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_date', isLessThanOrEqualTo: epoch)
        .where('is_closed', isEqualTo: false)
        .where('is_paid', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> streamAllChitByDate(String financeId,
      String branchName, String subBranchName, bool isClosed, int epoch) {
    return getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_date', isEqualTo: epoch)
        .where('is_closed', isEqualTo: isClosed)
        .snapshots();
  }

  Future<List<ChitCollection>> getAllChitByDate(String financeId,
      String branchName, String subBranchName, bool isClosed, int epoch) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_date', isEqualTo: epoch)
        .where('is_closed', isEqualTo: isClosed)
        .getDocuments();

    List<ChitCollection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(ChitCollection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<ChitCollection>> allCollectionByDate(String financeId,
      String branchName, String subBranchName, int epoch) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_date', isEqualTo: epoch)
        .getDocuments();

    List<ChitCollection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(ChitCollection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<ChitCollection>> getAllCollectionsByDateRange(String financeId,
      String branchName, String subBranchName, int start, int end) async {
    var collDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('chit_date', isGreaterThanOrEqualTo: start)
        .where('chit_date', isLessThanOrEqualTo: end)
        .getDocuments();

    List<ChitCollection> colls = [];
    if (collDocs.documents.isNotEmpty) {
      for (var doc in collDocs.documents) {
        colls.add(ChitCollection.fromJson(doc.data));
      }
    }

    return colls;
  }

  Future<List<ChitCollection>> getAllCollectionDetailsByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      List<int> dates) async {
    var collectionDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('collected_on', arrayContainsAny: dates)
        .getDocuments();

    List<ChitCollection> collections = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        collections.add(ChitCollection.fromJson(doc.data));
      }
    }

    return collections;
  }

  Stream<QuerySnapshot> streamCollectionsForChit(String financeId,
      String branchName, String subBranchName, int chitID, int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .snapshots();
  }

  Stream<QuerySnapshot> streamUpcomingForChit(String financeId,
      String branchName, String subBranchName, int chitID, int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .where('chit_date',
            isGreaterThan: DateUtils.getUTCDateEpoch(DateTime.now()))
        .snapshots();
  }

  Stream<QuerySnapshot> streamTodaysForChit(String financeId, String branchName,
      String subBranchName, int chitID, int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .where('chit_date',
            isEqualTo: DateUtils.getUTCDateEpoch(DateTime.now()))
        .snapshots();
  }

  Stream<QuerySnapshot> streamPastForChit(String financeId, String branchName,
      String subBranchName, int chitID, int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .where('chit_date',
            isLessThan: DateUtils.getUTCDateEpoch(DateTime.now()))
        .snapshots();
  }

  Future<List<ChitCollection>> getByCollectionNumber(
      String financeID,
      String branchName,
      String subBranchName,
      int chitID,
      int chitNumber) async {
    var collectionDocs = await getCollectionRef(
            financeID, branchName, subBranchName, chitID, chitNumber)
        .getDocuments();

    List<ChitCollection> chits = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        chits.add(ChitCollection.fromJson(doc.data));
      }
    }

    return chits;
  }

  Future<List<ChitCollection>> getAllCollections() async {
    var collectionDocs = await getGroupQuery().getDocuments();

    List<ChitCollection> chits = [];
    if (collectionDocs.documents.isNotEmpty) {
      for (var doc in collectionDocs.documents) {
        chits.add(ChitCollection.fromJson(doc.data));
      }
    }

    return chits;
  }

  Future<ChitCollection> getCollectionByID(String financeId, String branchName,
      String subBranchName, int chitID, int chitNumber, String docID) async {
    DocumentSnapshot snapshot = await getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .document(docID)
        .get();

    if (snapshot.exists) {
      return ChitCollection.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Stream<DocumentSnapshot> streamCollectionByID(
      String financeId,
      String branchName,
      String subBranchName,
      int chitID,
      int number,
      int chitNumber) {
    return getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .document(getDocumentID(number))
        .snapshots();
  }

  Future<void> update(
      String financeId,
      String branchName,
      String subBranchName,
      int chitID,
      int chitNumber,
      String docID,
      Map<String, dynamic> collJSON) async {
    collJSON['updated_at'] = DateTime.now();

    await getCollectionRef(
            financeId, branchName, subBranchName, chitID, chitNumber)
        .document(docID)
        .updateData(collJSON);
  }

  Future updateCollectionDetails(
      String financeId,
      String branchName,
      String subBranchName,
      int chitID,
      int mNumber,
      int chitNumber,
      bool isPaid,
      bool isAdd,
      Map<String, dynamic> data) async {
    Map<String, dynamic> fields = Map();

    DocumentReference docRef = this.getDocumentReference(
        financeId, branchName, subBranchName, chitID, mNumber, chitNumber);

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
      DocumentReference finDocRef = cachedLocalUser.getFinanceDocReference();

      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              if (isAdd) {
                accData.cashInHand += data['amount'];
              } else {
                accData.cashInHand -= data['amount'];
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
