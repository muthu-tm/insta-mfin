import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coll_template.g.dart';

@JsonSerializable(explicitToJson: true)
class CollectionTemp {
  UserController _uc = UserController();

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
  @JsonKey(name: 'tenure_type', nullable: true)
  int tenureType;
  @JsonKey(name: 'collection_amount', nullable: true)
  int collectionAmount;
  @JsonKey(name: 'interest_rate', nullable: true)
  double interestRate;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  CollectionTemp();

  setTempName(String name) {
    this.name = name;
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

  setCollectionAmount(int amount) {
    this.collectionAmount = amount;
  }

  setInterestRate(double iRate) {
    this.interestRate = iRate;
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

  factory CollectionTemp.fromJson(Map<String, dynamic> json) =>
      _$CollectionTempFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionTempToJson(this);

  DocumentReference getCurrentFinanceRef() {
    return _uc.getCurrentUser().getFinanceDocReference();
  }

  CollectionReference getCollectionRef() {
    return getCurrentFinanceRef().collection("collection_templates");
  }

  DocumentReference getDocumentReference() {
    return getCollectionRef().document(getDocumentID());
  }

  String getDocumentID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Future createTemplate() async {
    this.addedBy = _uc.getCurrentUser().mobileNumber;
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();

    await getCollectionRef()
        .document(getDocumentID())
        .setData(this.toJson());
  }

  Stream<QuerySnapshot> streamTemplates() {
    return getCollectionRef().snapshots();
  }

  Future<List<CollectionTemp>> getAllTemplates() async {
    var tempDocs = await getCollectionRef().getDocuments();

    if (tempDocs.documents.isEmpty) {
      throw 'No Templates found!';
    }

    List<CollectionTemp> temps = [];

    for (var doc in tempDocs.documents) {
      var temp = CollectionTemp.fromJson(doc.data);
      temps.add(temp);
    }

    return temps;
  }

  Future<CollectionTemp> getTemplateByID(String tempID) async {
    DocumentSnapshot snapshot =
        await getCollectionRef().document(tempID).get();

    if (snapshot.exists) {
      return CollectionTemp.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future<void> update(String tempID,
      Map<String, dynamic> tempJSON) async {
    tempJSON['updated_at'] = DateTime.now();

    await getDocumentReference().updateData(tempJSON);
  }

  Future remove(String tempID) async {
    await getCollectionRef().document(tempID).delete();
  }
}
