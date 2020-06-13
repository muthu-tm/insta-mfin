import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/enums/collection_type.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(explicitToJson: true)
class Payment extends Model {
  static CollectionReference _paymentCollRef =
      Model.db.collection("customer_payments");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'customer_number', nullable: true)
  int customerNumber;
  @JsonKey(name: 'date_of_payment', nullable: true)
  int dateOfPayment;
  @JsonKey(name: 'total_amount', nullable: true)
  int totalAmount;
  @JsonKey(name: 'principal_amount', nullable: true)
  int principalAmount;
  @JsonKey(name: 'doc_charge', nullable: true)
  int docCharge;
  @JsonKey(name: 'surcharge', nullable: true)
  int surcharge;
  @JsonKey(name: 'tenure', nullable: true)
  int tenure;
  @JsonKey(name: 'collection_mode', nullable: true)
  int collectionMode;
  @JsonKey(name: 'collection_day', nullable: true)
  int collectionDay;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_amount', nullable: true)
  int collectionAmount;
  @JsonKey(name: 'collection_starts_from', nullable: true)
  int collectionStartsFrom;
  @JsonKey(name: 'settled_date', nullable: true)
  int settledDate;
  @JsonKey(name: 'is_settled', defaultValue: false)
  bool isSettled;
  @JsonKey(name: 'is_loss', defaultValue: false)
  bool isLoss;
  @JsonKey(name: 'profit_amount', defaultValue: 0)
  int profitAmount;
  @JsonKey(name: 'loss_amount', defaultValue: 0)
  int lossAmount;
  @JsonKey(name: 'shortage_amount', defaultValue: 0)
  int shortageAmount;
  @JsonKey(name: 'given_by', nullable: true)
  String givenBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Payment();

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

  setTotalAmount(int amount) {
    this.totalAmount = amount;
  }

  setPrincipalAmount(int pricipal) {
    this.principalAmount = pricipal;
  }

  setDocumentCharge(int docCharge) {
    this.docCharge = docCharge;
  }

  setSurcharge(int surcharge) {
    this.surcharge = surcharge;
  }

  setTenure(int tenure) {
    this.tenure = tenure;
  }

  setCollectionMode(int collectionMode) {
    this.collectionMode = collectionMode;
  }

  setCollectionDay(int collectionDay) {
    this.collectionDay = collectionDay;
  }

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
  }

  setInterestRate(double iRate) {
    this.interestRate = iRate;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setDOP(int date) {
    this.dateOfPayment = date;
  }

  setCSF(int date) {
    this.collectionStartsFrom = date;
  }

  setIsSettled(bool isSettled) {
    this.isSettled = isSettled;
  }

  setGivenBy(String givenBy) {
    this.givenBy = givenBy;
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

  String getMode() {
    if (this.collectionMode == 0)
      return "Daily";
    else if (this.collectionMode == 1)
      return "Weekly";
    else
      return "Monthly";
  }

  Future<int> getTotalReceived() async {
    try {
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);
      int received = 0;
      collList.forEach((coll) {
        if (coll.type != CollectionType.DocCharge.name &&
            coll.type != CollectionType.Surcharge.name)
          received += coll.getReceived();
      });

      return received;
    } catch (err) {
      print("Unable to get Payment's Total Paid amount!" + err.toString());
      return null;
    }
  }

  Future<int> getTotalPending() async {
    try {
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);
      int pending = 0;
      collList.forEach((coll) {
        if (coll.type != CollectionType.DocCharge.name &&
            coll.type != CollectionType.Surcharge.name)
          pending += coll.getPending();
      });

      return pending;
    } catch (err) {
      print("Unable to get Payment's Total Paid amount!" + err.toString());
      return 0;
    }
  }

  Future<List<int>> getAmountDetails() async {
    try {
      if (this.isSettled) {
        int rAmount = await getTotalReceived();
        return [rAmount, 0, 0, 0];
      }
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);

      int _r = 0;
      int _p = 0;
      int _c = 0;
      int _u = 0;
      collList.forEach((coll) {
        if (coll.type != CollectionType.DocCharge.name &&
            coll.type != CollectionType.Surcharge.name) {
          _r += coll.getReceived();
          _p += coll.getPending();
          _c += coll.getCurrent();
          _u += coll.getUpcoming();
        }
      });

      return [_r, _p, _c, _u];
    } catch (err) {
      print("Unable to get Payment's amount details!" + err.toString());
      return [];
    }
  }

  Future<List<int>> getStatus() async {
    try {
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);

      List<int> status = [];
      for (var coll in collList) {
        int cstatus = coll.getStatus();
        if (!status.contains(cstatus)) status.add(cstatus);
      }

      return status;
    } catch (err) {
      print("Unable to get Payment's amount details!" + err.toString());
      return [];
    }
  }

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  CollectionReference getCollectionRef() {
    return _paymentCollRef;
  }

  String getID() {
    String value = this.financeID +
        this.branchName +
        this.subBranchName +
        this.customerNumber.toString();

    return HashGenerator.hmacGenerator(
        value, this.createdAt.millisecondsSinceEpoch.toString());
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('customer_payments');
  }

  String getDocumentID(String financeId, String branchName,
      String subBranchName, int custNumber, DateTime createdAt) {
    String value =
        financeId + branchName + subBranchName + custNumber.toString();
    return HashGenerator.hmacGenerator(
        value, createdAt.millisecondsSinceEpoch.toString());
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) {
    return getCollectionRef().document(
        getDocumentID(financeId, branchName, subBranchName, number, createdAt));
  }

  Future create(int number) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primaryFinance;
    this.branchName = user.primaryBranch;
    this.subBranchName = user.primarySubBranch;
    try {
      DocumentReference finDocRef = user.getFinanceDocReference();
      // DocumentSnapshot doc = await finDocRef.get();
      // if (doc.exists) {
      //   AccountsData accData = AccountsData.fromJson(doc.data['accounts_data']);

      //   accData.cashInHand.update(
      //             DateUtils.getCashInHandDate(this.dateOfPayment),
      //             (value) => (value - this.principalAmount),
      //             ifAbsent: () => (this.principalAmount));

      //   if (accData.cashInHand < 0) {
      //     throw 'Low Cash In Hand to make this Payment! If you have more money, Add using Journal Entry!';
      //   }
      // } else {
      //   throw 'Unable to find your finance details!';
      // }

      await Model.db.runTransaction(
        (tx) async {
          return tx.get(finDocRef).then(
            (doc) {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              accData.cashInHand -= this.principalAmount;

              // if (accData.cashInHand < 0) {
              //   return Future.error(
              //       'Low Cash In Hand to make this Payment! If you have more money, Add using Journal Entry!');
              accData.paymentsAmount += this.totalAmount;
              accData.totalPayments += 1;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);

              return txCreate(
                tx,
                this.getDocumentReference(this.financeID, this.branchName,
                    this.subBranchName, this.customerNumber, this.createdAt),
                this.toJson(),
              );
            },
          );
        },
      );
    } catch (err) {
      print('Payment CREATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Future<Map<int, List<Payment>>> getAllActivePayments(
      String financeId, String branchName, String subBranchName) async {
    QuerySnapshot snap = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('is_settled', isEqualTo: false)
        .getDocuments();

    Map<int, List<Payment>> payMap = new Map();
    if (snap.documents.isNotEmpty) {
      for (int i = 0; i < snap.documents.length; i++) {
        Payment pay = Payment.fromJson(snap.documents[i].data);
        List<int> status = await pay.getStatus();
        for (int _s in status) {
          payMap.update(_s, (value) {
            List<Payment> _e = value;
            _e.add(pay);
            return _e;
          }, ifAbsent: () => [pay]);
        }
      }
    }

    return payMap;
  }

  Stream<QuerySnapshot> streamPayments(
      String financeId, String branchName, String subBranchName, int number) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('customer_number', isEqualTo: number)
        .snapshots();
  }

  Future<List<Payment>> getAllPaymentsForCustomer(String financeId,
      String branchName, String subBranchName, int number) async {
    var paymentDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('customer_number', isEqualTo: number)
        .getDocuments();

    List<Payment> payments = [];
    if (paymentDocs.documents.isNotEmpty) {
      for (var doc in paymentDocs.documents) {
        payments.add(Payment.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<List<Payment>> getAllPaymentsByDate(String financeId,
      String branchName, String subBranchName, int epoch) async {
    var paymentDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('date_of_payment', isEqualTo: epoch)
        .getDocuments();

    List<Payment> payments = [];
    if (paymentDocs.documents.isNotEmpty) {
      for (var doc in paymentDocs.documents) {
        payments.add(Payment.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<List<Payment>> getAllPaymentsByDateRange(String financeId,
      String branchName, String subBranchName, int start, int end) async {
    var paymentDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('date_of_payment', isGreaterThanOrEqualTo: start)
        .where('date_of_payment', isLessThanOrEqualTo: end)
        .getDocuments();

    List<Payment> payments = [];
    if (paymentDocs.documents.isNotEmpty) {
      for (var doc in paymentDocs.documents) {
        payments.add(Payment.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<Payment> getPaymentByID(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) async {
    Map<String, dynamic> payment = await getByID(
        getDocumentID(financeId, branchName, subBranchName, number, createdAt));

    if (payment != null) {
      return Payment.fromJson(payment);
    } else {
      return null;
    }
  }

  Future<void> updatePayment(
      Payment payment, Map<String, dynamic> paymentJSON) async {
    paymentJSON['updated_at'] = DateTime.now();

    DocumentReference docRef = getDocumentReference(
        payment.financeID,
        payment.branchName,
        payment.subBranchName,
        payment.customerNumber,
        payment.createdAt);

    int amount = 0;
    int totalAmount = 0;

    if (paymentJSON.containsKey('principal_amount')) {
      amount = paymentJSON['principal_amount'] - payment.principalAmount;
    }

    if (paymentJSON.containsKey('total_amount')) {
      totalAmount = paymentJSON['total_amount'] - payment.principalAmount;
    }

    try {
      DocumentReference finDocRef = user.getFinanceDocReference();
      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              accData.cashInHand += amount;
              accData.paymentsAmount += totalAmount;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);
              txUpdate(tx, docRef, paymentJSON);
            },
          );
        },
      );
    } catch (err) {
      print('Payment UPDATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Future<void> settlement(Map<String, dynamic> paymentJSON) async {
    Map<String, dynamic> payJSON = {
      'updated_at': DateTime.now(),
      'is_settled': true,
      'settled_date': paymentJSON['settled_date']
    };

    DocumentReference docRef = getDocumentReference(
        this.financeID,
        this.branchName,
        this.subBranchName,
        this.customerNumber,
        this.createdAt);

    try {
      DocumentReference finDocRef = user.getFinanceDocReference();
      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              QuerySnapshot cSnap = await this
                  .getDocumentRef(this.getID())
                  .collection('customer_collections')
                  .where('collection_date',
                      isGreaterThanOrEqualTo: paymentJSON['settled_date'])
                  .getDocuments();

              //remove all upcoming collections
              if (cSnap.documents.length > 0) {
                for (int i = 0; i < cSnap.documents.length; i++) {
                  Collection _c = Collection.fromJson(cSnap.documents[i].data);
                  if (_c.getReceived() == 0) {
                    txDelete(tx, cSnap.documents[i].reference);
                  }
                }
              }

              if (paymentJSON['settlement_amount'] > 0) {
                QuerySnapshot sSnap = await this
                    .getDocumentRef(this.getID())
                    .collection('customer_collections')
                    .where('type', isEqualTo: 3)
                    .getDocuments();

                Map<String, dynamic> fields = Map();
                Map<String, dynamic> collDetails = {
                  'amount': paymentJSON['settlement_amount']
                };
                collDetails['collected_on'] = paymentJSON['settled_date'];
                collDetails['created_at'] = DateTime.now();
                collDetails['added_by'] = user.mobileNumber;
                collDetails['is_paid_late'] = false;
                collDetails['notes'] = paymentJSON['received_from'];
                collDetails['collected_by'] = user.name;
                collDetails['collected_from'] = paymentJSON['received_from'];

                if (sSnap.documents.length > 0) {
                  Collection sColl =
                      Collection.fromJson(sSnap.documents[0].data);
                  if (sColl.collectionDate < paymentJSON['settled_date'])
                    collDetails['is_paid_late'] = true;

                  if (sColl.collectedOn.contains(paymentJSON['settled_date'])) {
                    String sDate = DateUtils.formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            paymentJSON['settled_date']));
                    throw "A Settlement added for the date $sDate; You cannot add two amount for same DAY!";
                  } else if (sColl.getReceived() > 0) {
                    fields['updated_at'] = DateTime.now();
                    fields['collected_on'] =
                        FieldValue.arrayUnion([paymentJSON['settled_date']]);
                    fields['collections'] =
                        FieldValue.arrayUnion([collDetails]);
                    txUpdate(tx, sSnap.documents[0].reference, fields);
                  } else {
                    Map<String, dynamic> data = {
                      'finance_id': this.financeID,
                      'branch_name': this.branchName,
                      'sub_branch_name': this.subBranchName,
                      'collection_amount': paymentJSON['settlement_amount'],
                      'customer_number': this.customerNumber,
                      'collection_date': paymentJSON['settled_date'],
                      'collected_on': [paymentJSON['settled_date']],
                      'collections': [collDetails],
                      'type': 3, //3 - Settlement
                      'collection_number': this.tenure,
                      'created_at': DateTime.now(),
                    };
                    txCreate(
                        tx,
                        Collection().getDocumentReference(
                            this.financeID,
                            this.branchName,
                            this.subBranchName,
                            this.customerNumber,
                            this.createdAt,
                            paymentJSON['settled_date']),
                        data);
                  }
                } else {
                  Map<String, dynamic> data = {
                    'finance_id': this.financeID,
                    'branch_name': this.branchName,
                    'sub_branch_name': this.subBranchName,
                    'collection_amount': paymentJSON['settlement_amount'],
                    'customer_number': this.customerNumber,
                    'collection_date': paymentJSON['settled_date'],
                    'collected_on': [paymentJSON['settled_date']],
                    'collections': [collDetails],
                    'type': 3, //3 - Settlement
                    'collection_number': this.tenure,
                    'created_at': DateTime.now(),
                  };
                  txCreate(
                      tx,
                      Collection().getDocumentReference(
                          this.financeID,
                          this.branchName,
                          this.subBranchName,
                          this.customerNumber,
                          this.createdAt,
                          paymentJSON['settled_date']),
                      data);
                }
              }

              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              accData.cashInHand += paymentJSON['settlement_amount'];
              accData.paymentsAmount -= this.totalAmount;
              accData.totalPayments -= 1;

              if (paymentJSON['loss']) {
                payJSON['is_loss'] = true;
                payJSON['loss_amount'] = paymentJSON['loss_amount'];
              } else {
                payJSON['is_loss'] = false;
                payJSON['profit_amount'] = paymentJSON['profit_amount'];
              }

              payJSON['shortage_amount'] = paymentJSON['shortage_amount'];

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);

              txUpdate(tx, docRef, payJSON);
            },
          );
        },
      );
    } catch (err) {
      print('Payment UPDATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Future removePayment(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) async {
    DocumentReference docRef = getDocumentReference(
        financeId, branchName, subBranchName, number, createdAt);

    try {
      DocumentReference finDocRef = user.getFinanceDocReference();
      await Model.db.runTransaction(
        (tx) {
          return tx.get(finDocRef).then(
            (doc) async {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              DocumentSnapshot snap = await tx.get(docRef);

              if (!snap.exists) {
                Future.error('No Payment document found to Remove');
              }

              Payment payment = Payment.fromJson(snap.data);

              accData.cashInHand += payment.principalAmount;
              accData.paymentsAmount -= payment.totalAmount;
              accData.totalPayments -= 1;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);

              QuerySnapshot snapshot = await docRef
                  .collection('customer_collections')
                  .getDocuments();

              for (DocumentSnapshot ds in snapshot.documents) {
                txDelete(tx, ds.reference);
              }
              txDelete(tx, docRef);
            },
          );
        },
      );
    } catch (err) {
      print('Payment DELETE Transaction failure:' + err.toString());
      throw err;
    }
  }
}
