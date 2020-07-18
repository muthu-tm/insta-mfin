import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/chit_fund_details.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chit_template.g.dart';

@JsonSerializable(explicitToJson: true)
class ChitTemplate extends Model {
  UserController _uc = UserController();

  @JsonKey(name: 'template_name', nullable: true)
  String name;
  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'type', nullable: true)
  String type;
  @JsonKey(name: 'chit_amount', nullable: true)
  int chitAmount;
  @JsonKey(name: 'tenure', nullable: true)
  int tenure;
  @JsonKey(name: 'collection_day', nullable: true)
  int collectionDay;
  @JsonKey(name: 'fund_details')
  List<ChitFundDetails> fundDetails;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  ChitTemplate();

  setTempName(String name) {
    this.name = name;
  }

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setchitAmount(int amount) {
    this.chitAmount = amount;
  }

  setTenure(int tenure) {
    this.tenure = tenure;
  }

  setCollectionDay(int cDay) {
    this.collectionDay = cDay;
  }
  
  setType(String type) {
    this.type = type;
  }
  
  setFundDetails(List<ChitFundDetails> fundDetails) {
    this.fundDetails = fundDetails;
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

  int getProfitAmount() {
    int profit = 0;

    for (ChitFundDetails chit in this.fundDetails) {
      profit += chit.profit;
    }

    return profit;
  }

  factory ChitTemplate.fromJson(Map<String, dynamic> json) =>
      _$ChitTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ChitTemplateToJson(this);

  DocumentReference getCurrentFinanceRef() {
    return _uc.getCurrentUser().getFinanceDocReference();
  }

  CollectionReference getCollectionRef() {
    return getCurrentFinanceRef().collection("chit_templates");
  }

  DocumentReference getDocumentReference() {
    return getCollectionRef().document(getDocumentID());
  }

  String getDocumentID() {
    return this.createdAt.millisecondsSinceEpoch.toString();
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('chit_fund');
  }

  Future createTemplate() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primary.financeID;
    this.branchName = user.primary.branchName;
    this.subBranchName = user.primary.subBranchName;
    try {
      await getCollectionRef().document(getDocumentID()).setData(this.toJson());
    } catch (err) {
      print('Chit Publish failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamChitTemplates() {
    return getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .snapshots();
  }
  
  Future<List<ChitTemplate>> getAllChitTemplates() async {
    QuerySnapshot snap = await getCollectionRef()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .getDocuments();
      
      List<ChitTemplate> temps = [];

      if (snap.documents.isNotEmpty) {
        snap.documents.forEach((tempData) {
          temps.add(ChitTemplate.fromJson(tempData.data));
        });
      }

      return temps;
  }

  Future<ChitTemplate> getTemplateByID(String tempID) async {
    DocumentSnapshot snapshot = await getCollectionRef().document(tempID).get();

    if (snapshot.exists) {
      return ChitTemplate.fromJson(snapshot.data);
    } else {
      return null;
    }
  }

  Future removeChitTemplate(String docID) async {
    DocumentReference docRef = getCollectionRef().document(docID);

    try {
      await docRef.delete();
    } catch (err) {
      print('Chit Template DELETE failure:' + err.toString());
      throw err;
    }
  }
}
