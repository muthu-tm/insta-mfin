import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_template.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentTemplate {

  @JsonKey(name: 'template_name', nullable: true)
  String name;
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
  @JsonKey(name: 'collection_days', nullable: true)
  List<int> collectionDays;
  @JsonKey(name: 'collection_amount', nullable: true)
  int collectionAmount;
  @JsonKey(name: 'interest_amount', nullable: true)
  int interestAmount;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  PaymentTemplate();

  setTempName(String name) {
    this.name = name;
  }

  setTotalAmount(int amount) {
    this.totalAmount = amount;
  }

  setPrincipalAmount(int principal) {
    this.principalAmount = principal;
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

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
  }

  void setCollectionDays(List<int> collectionDay) {
    this.collectionDays = collectionDay;
  }

  setInterestAmount(int iAmount) {
    this.interestAmount = iAmount;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory PaymentTemplate.fromJson(Map<String, dynamic> json) =>
      _$PaymentTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTemplateToJson(this);

  DocumentReference getCurrentFinanceRef() {
    return cachedLocalUser.getFinanceDocReference();
  }

  CollectionReference getCollectionRef() {
    return getCurrentFinanceRef().collection("payment_templates");
  }

  DocumentReference getDocumentReference() {
    return getCollectionRef().document(getDocumentID());
  }

  String getDocumentID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Future createTemplate() async {
    this.addedBy = cachedLocalUser.getIntID();
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await getCollectionRef()
        .document(getDocumentID())
        .setData(this.toJson());
  }

  Stream<QuerySnapshot> streamTemplates() {
    return getCollectionRef().snapshots();
  }

  Future<List<PaymentTemplate>> getAllTemplates() async {
    var tempDocs = await getCollectionRef().getDocuments();

    if (tempDocs.documents.isEmpty) {
      throw 'No Templates found!';
    }

    List<PaymentTemplate> temps = [];

    for (var doc in tempDocs.documents) {
      var temp = PaymentTemplate.fromJson(doc.data);
      temps.add(temp);
    }

    return temps;
  }

  Future<PaymentTemplate> getTemplateByID(String tempID) async {
    DocumentSnapshot snapshot =
        await getCollectionRef().document(tempID).get();

    if (snapshot.exists) {
      return PaymentTemplate.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future<void> update(String tempID,
      Map<String, dynamic> tempJSON) async {
    tempJSON['updated_at'] = DateTime.now();

    await getCollectionRef().document(tempID).updateData(tempJSON);
  }

  Future remove(String tempID) async {
    await getCollectionRef().document(tempID).delete();
  }

}
