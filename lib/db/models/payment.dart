import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/customer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable(explicitToJson: true)
class Payment {
  Customer cust = Customer();

  @JsonKey(name: 'date_of_payment', nullable: true)
  String dateOfPayment;
  @JsonKey(name: 'total_amount', nullable: true)
  int totalAmount;
  @JsonKey(name: 'principal_amount', nullable: true)
  int principalAmount;
  @JsonKey(name: 'doc_charge', nullable: true)
  int docCharge;
  @JsonKey(name: 'surcharge', nullable: true)
  int surcharge;
  @JsonKey(name: 'total_paid', nullable: true)
  int totalPaid;
  @JsonKey(name: 'tenure', nullable: true)
  int tenure;
  @JsonKey(name: 'tenure_type', nullable: true)
  int tenureType;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'collection_amount', nullable: true)
  int collectionAmount;
  @JsonKey(name: 'given_by', nullable: true)
  String givenBy;
  @JsonKey(name: 'given_to', nullable: true)
  String givenTo;
  @JsonKey(name: 'payments_status', nullable: true)
  int status;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Payment();

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

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
  }

  setInterestRate(double iRate) {
    this.interestRate = iRate;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setDOP(String date) {
    this.dateOfPayment = date;
  }

  setTotalPaid(int paid) {
    this.totalPaid = paid;
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

  setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  CollectionReference getPaymentCollectionRef(int number) {
    return cust
        .getCollectionRef()
        .document(cust.getDocumentID(number))
        .collection("payments");
  }

  String getDocumentID(DateTime createdAt) {
    return createdAt.millisecondsSinceEpoch.toString();
  }

  DocumentReference getDocumentReference(int number, DateTime createdAt) {
    return getPaymentCollectionRef(number).document(getDocumentID(createdAt));
  }

  Future<Payment> create(int number) async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await getDocumentReference(number, this.createdAt).setData(this.toJson());

    return this;
  }

  Future<bool> isExist(int number, DateTime createdAt) async {
    var snap = await getDocumentReference(number, createdAt).get();

    return snap.exists;
  }

  Stream<QuerySnapshot> streamPayments(int number) {
    return getPaymentCollectionRef(number).snapshots();
  }

  Future<List<Payment>> getAllPayments(int number) async {
    var paymentDocs = await getPaymentCollectionRef(number).getDocuments();

    if (paymentDocs.documents.isEmpty) {
      throw 'No Payments found for $number';
    }

    List<Payment> payments = [];

    for (var doc in paymentDocs.documents) {
      payments.add(Payment.fromJson(doc.data));
    }

    return payments;
  }

  Future<Payment> getPaymentByName(int number, DateTime createdAt) async {
    String docId = getDocumentID(createdAt);

    var paymentSnap =
        await getPaymentCollectionRef(number).document(docId).get();
    if (!paymentSnap.exists) {
      return null;
    }

    return Payment.fromJson(paymentSnap.data);
  }

  Future<Payment> getPaymentByID(int number, String docID) async {
    DocumentSnapshot snapshot =
        await getPaymentCollectionRef(number).document(docID).get();

    if (snapshot.exists) {
      return Payment.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future<void> update(
      int number, String docID, Map<String, dynamic> paymentJSON) async {
    paymentJSON['updated_at'] = DateTime.now();

    await getPaymentCollectionRef(number)
        .document(docID)
        .updateData(paymentJSON);
  }
}
