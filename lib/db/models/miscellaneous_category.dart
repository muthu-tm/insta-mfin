import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'miscellaneous_category.g.dart';

@JsonSerializable(explicitToJson: true)
class MiscellaneousCategory extends Model {
  User user = UserController().getCurrentUser();

  static CollectionReference _miscellaneousCollRef =
      Model.db.collection("miscellaneous_categories");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'category_name', nullable: true)
  String categoryName;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  MiscellaneousCategory();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setCategory(String name) {
    this.categoryName = name;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  factory MiscellaneousCategory.fromJson(Map<String, dynamic> json) =>
      _$MiscellaneousCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$MiscellaneousCategoryToJson(this);

  CollectionReference getCollectionRef() {
    return _miscellaneousCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;
    return HashGenerator.hmacGenerator(
        value, this.categoryName);
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('miscellaneous_category');
  }

  String getDocumentID(String financeId, String branchName,
      String subBranchName, String name) {
    String value = financeID + branchName + subBranchName;
    return HashGenerator.hmacGenerator(
        value, name);
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, String name) {
    return getCollectionRef().document(
        getDocumentID(financeId, branchName, subBranchName, name));
  }

  Future<MiscellaneousCategory> create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primaryFinance;
    this.branchName = user.primaryBranch;
    this.subBranchName = user.primarySubBranch;

    await super.add(this.toJson());

    return this;
  }

  Stream<QuerySnapshot> streamExpenses(
      String financeId, String branchName, String subBranchName) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .snapshots();
  }

  Future<List<MiscellaneousCategory>> getAllExpensesByAddedUser(
      String financeId, String branchName, String subBranchName, int addedBy) async {
    QuerySnapshot snapDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('added_by', isEqualTo: addedBy).getDocuments();

    if (snapDocs.documents.isEmpty) {
      return [];
    }

    List<MiscellaneousCategory> expenses = [];
    snapDocs.documents.forEach((e) {
      expenses.add(MiscellaneousCategory.fromJson(e.data));
    });

    return expenses;
  }
}
