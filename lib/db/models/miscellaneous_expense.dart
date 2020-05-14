import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/miscellaneous_category.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'miscellaneous_expense.g.dart';

@JsonSerializable(explicitToJson: true)
class MiscellaneousExpense extends Model {
  static CollectionReference _miscellaneousCollRef =
      Model.db.collection("miscellaneous_expenses");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'expense_name')
  String expenseName;
  @JsonKey(name: 'category', nullable: true)
  MiscellaneousCategory category;
  @JsonKey(name: 'amount', nullable: true)
  int amount;
  @JsonKey(name: 'expense_date')
  DateTime expenseDate;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  MiscellaneousExpense();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setExpenseName(String name) {
    this.expenseName = name;
  }

  setCategory(MiscellaneousCategory category) {
    this.category = category;
  }

  setAmount(int amount) {
    this.amount = amount;
  }

  setExpenseDate(DateTime expenseDate) {
    this.expenseDate = expenseDate;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  factory MiscellaneousExpense.fromJson(Map<String, dynamic> json) =>
      _$MiscellaneousExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$MiscellaneousExpenseToJson(this);

  CollectionReference getCollectionRef() {
    return _miscellaneousCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;
    return HashGenerator.hmacGenerator(
        value, this.createdAt.millisecondsSinceEpoch.toString());
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('miscellaneous_expenses');
  }

  String getDocumentID(String financeID, String branchName,
      String subBranchName, DateTime createdAt) {
    String value = financeID + branchName + subBranchName;
    return HashGenerator.hmacGenerator(
        value, createdAt.millisecondsSinceEpoch.toString());
  }

  DocumentReference getDocumentReference(String financeId, String branchName,
      String subBranchName, DateTime createdAt) {
    return getCollectionRef().document(
        getDocumentID(financeId, branchName, subBranchName, createdAt));
  }

  Future create() async {
    this.createdAt = DateTime.now();
    this.updatedAt = DateTime.now();
    this.financeID = user.primaryFinance;
    this.branchName = user.primaryBranch;
    this.subBranchName = user.primarySubBranch;
    this.addedBy = user.mobileNumber;

    try {
      DocumentReference finDocRef = user.getFinanceDocReference();

      await Model.db.runTransaction(
        (tx) async {
          return tx.get(finDocRef).then(
            (doc) {
              AccountsData accData =
                  AccountsData.fromJson(doc.data['accounts_data']);

              accData.cashInHand -= this.amount;
              accData.miscellaneousExpenseAmount += this.amount;
              accData.miscellaneousExpense += 1;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);

              txCreate(
                tx,
                this.getDocumentReference(
                    financeID, branchName, subBranchName, createdAt),
                this.toJson(),
              );
            },
          );
        },
      );
      print('Miscellaneous CREATE Transaction success!');
    } catch (err) {
      print('Miscellaneous CREATE Transaction failure:' + err.toString());
    }
  }

  Stream<QuerySnapshot> streamExpenses(
      String financeId, String branchName, String subBranchName) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .snapshots();
  }

  Future<List<MiscellaneousExpense>> getAllExpenses(
      String financeId, String branchName, String subBranchName) async {
    QuerySnapshot snapDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .getDocuments();

    if (snapDocs.documents.isEmpty) {
      return [];
    }

    List<MiscellaneousExpense> expenses = [];
    snapDocs.documents.forEach((e) {
      expenses.add(MiscellaneousExpense.fromJson(e.data));
    });

    return expenses;
  }

  Future removeExpense(String financeID, String branchName,
      String subBranchName, DateTime createdAt) async {
    DocumentReference docRef = this
        .getDocumentReference(financeID, branchName, subBranchName, createdAt);

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
                throw 'No Miscellaneous Expense document found';
              }

              MiscellaneousExpense expense =
                  MiscellaneousExpense.fromJson(snap.data);

              accData.cashInHand += expense.amount;
              accData.miscellaneousExpenseAmount -= expense.amount;
              accData.miscellaneousExpense -= 1;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              // Update finance details
              txUpdate(tx, finDocRef, data);

              // Remove Expense
              txDelete(
                  tx,
                  this.getDocumentReference(
                      financeID, branchName, subBranchName, createdAt));
            },
          );
        },
      );
      print('Miscellaneous Expense DELETE Transaction success!');
    } catch (err) {
      print(
          'Miscellaneous Expense DELETE Transaction failure:' + err.toString());
    }
  }
}
