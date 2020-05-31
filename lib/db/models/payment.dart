import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/enums/collection_type.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/collection.dart';
import 'package:instamfin/db/models/model.dart';
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
  DateTime dateOfPayment;
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
  @JsonKey(name: 'tenure_type', nullable: true)
  int tenureType;
  @JsonKey(name: 'collection_day', nullable: true)
  int collectionDay;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_amount', nullable: true)
  int collectionAmount;
  @JsonKey(name: 'collection_starts_from', nullable: true)
  DateTime collectionStartsFrom;
  @JsonKey(name: 'closing_date', nullable: true)
  DateTime closingDate;
  @JsonKey(name: 'status', nullable: true)
  int status;
  @JsonKey(name: 'given_by', nullable: true)
  String givenBy;
  @JsonKey(name: 'given_to', nullable: true)
  String givenTo;
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

  setTenureType(int tenureType) {
    this.tenureType = tenureType;
  }

  setCollectionDay(int weekDay) {
    this.collectionDay = weekDay;
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

  setDOP(DateTime date) {
    this.dateOfPayment = date;
  }

  setCSF(DateTime date) {
    this.collectionStartsFrom = date;
  }

  setPCD(DateTime closingDate) {
    this.closingDate = closingDate;
  }

  setGivenBy(String givenBy) {
    this.givenBy = givenBy;
  }

  setGivenTo(String givenTo) {
    this.givenTo = givenTo;
  }

  setPaymentStatus(int status) {
    this.status = status;
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

  Future<int> getTotalPaid() async {
    try {
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);
      int totalPaid = 0;
      collList.forEach((coll) {
        if (coll.type != CollectionType.DocCharge.name &&
            coll.type != CollectionType.Surcharge.name)
          totalPaid += coll.getAmountPaid();
      });

      return totalPaid;
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
          pending += coll.getPendingAmount();
      });

      return pending;
    } catch (err) {
      print("Unable to get Payment's Total Paid amount!" + err.toString());
      return 0;
    }
  }

  Future<List<int>> getAmountDetails() async {
    try {
      List<Collection> collList = await Collection()
          .getAllCollectionsForCustomerPayment(this.financeID, this.branchName,
              this.subBranchName, this.customerNumber, this.createdAt);

      int totalPaid = 0;
      int pending = 0;
      int current = 0;
      int upcoming = 0;
      collList.forEach((coll) {
        if (coll.type != CollectionType.DocCharge.name &&
            coll.type != CollectionType.Surcharge.name) {
          totalPaid += coll.getAmountPaid();
          pending += coll.getPendingAmount();
          current += coll.getCurrentAmount();
          upcoming += coll.getUpcomingAmount();
        }
      });

      return [totalPaid, pending, current, upcoming];
    } catch (err) {
      print("Unable to get Payment's amount details!" + err.toString());
      return null;
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
      DocumentSnapshot doc = await finDocRef.get();
      if (doc.exists) {
        AccountsData accData = AccountsData.fromJson(doc.data['accounts_data']);

        accData.cashInHand -= this.principalAmount;

        if (accData.cashInHand < 0) {
          throw 'Low Cash In Hand to make this Payment! If you have more money, Add using Journal Entry!';
        }
      } else {
        throw 'Unable to find your finance details!';
      }

      await Model.db.runTransaction(
        (tx) async {
          return tx.get(finDocRef).then(
            (doc) {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              accData.cashInHand -= this.principalAmount;

              if (accData.cashInHand < 0) {
                return Future.error(
                    'Low Cash In Hand to make this Payment! If you have more money, Add using Journal Entry!');
              } else {
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
              }
            },
          );
        },
      );
    } catch (err) {
      print('Payment CREATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Future<bool> isExist(String financeId, String branchName,
      String subBranchName, int number, DateTime createdAt) async {
    var snap = await getDocumentReference(
            financeId, branchName, subBranchName, number, createdAt)
        .get();

    return snap.exists;
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

  Future<List<Payment>> getAllPayments(
      String financeId, String branchName, String subBranchName) async {
    var paymentDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .getDocuments();

    List<Payment> payments = [];
    if (paymentDocs.documents.isNotEmpty) {
      for (var doc in paymentDocs.documents) {
        payments.add(Payment.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<List<Payment>> getAllPaymentsByDateRage(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime start,
      DateTime end) async {
    var paymentDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('date_of_payment', isGreaterThanOrEqualTo: start)
        .where('date_of_payment', isLessThan: end)
        .getDocuments();

    List<Payment> payments = [];
    if (paymentDocs.documents.isNotEmpty) {
      for (var doc in paymentDocs.documents) {
        payments.add(Payment.fromJson(doc.data));
      }
    }

    return payments;
  }

  Future<List<Payment>> getAllPaymentsByStatus(String financeId,
      String branchName, String subBranchName, int status) async {
    var paymentDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('status', isEqualTo: status)
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
              // Update finance details
              txUpdate(tx, finDocRef, data);

              // Remove Payment
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
              // Update finance details
              txUpdate(tx, finDocRef, data);

              QuerySnapshot snapshot = await docRef
                  .collection('customer_collections')
                  .getDocuments();

              // Remove Payment's collection
              for (DocumentSnapshot ds in snapshot.documents) {
                // ds.reference.delete();
                txDelete(tx, ds.reference);
              }

              // Remove Payment
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
