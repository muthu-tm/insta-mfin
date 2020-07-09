import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable(explicitToJson: true)
class Expense extends Model {
  static CollectionReference _expenseCollRef = Model.db.collection("expenses");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'expense_name')
  String expenseName;
  @JsonKey(name: 'category', nullable: true)
  ExpenseCategory category;
  @JsonKey(name: 'amount', nullable: true)
  int amount;
  @JsonKey(name: 'expense_date')
  int expenseDate;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Expense();

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

  setCategory(ExpenseCategory category) {
    this.category = category;
  }

  setAmount(int amount) {
    this.amount = amount;
  }

  setExpenseDate(int expenseDate) {
    this.expenseDate = expenseDate;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  CollectionReference getCollectionRef() {
    return _expenseCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;
    return HashGenerator.hmacGenerator(
        value, this.createdAt.millisecondsSinceEpoch.toString());
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('expenses');
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
    this.financeID = user.primary.financeID;
    this.branchName = user.primary.branchName;
    this.subBranchName = user.primary.subBranchName;
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
    } catch (err) {
      print('Expense CREATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamExpensesByDate(int epoch) {
    return getGroupQuery()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('expense_date', isEqualTo: epoch)
        .snapshots();
  }

  Stream<QuerySnapshot> streamExpensesByDateRange(int start, int end) {
    return getGroupQuery()
        .where('finance_id', isEqualTo: user.primary.financeID)
        .where('branch_name', isEqualTo: user.primary.branchName)
        .where('sub_branch_name', isEqualTo: user.primary.subBranchName)
        .where('expense_date', isGreaterThanOrEqualTo: start)
        .where('expense_date', isLessThanOrEqualTo: end)
        .orderBy('expense_date', descending: true)
        .snapshots();
  }

  Future<List<Expense>> getAllExpensesByDate(String financeId,
      String branchName, String subBranchName, int epoch) async {
    var expenseDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('expense_date', isEqualTo: epoch)
        .getDocuments();

    List<Expense> expenses = [];
    if (expenseDocs.documents.isNotEmpty) {
      for (var doc in expenseDocs.documents) {
        expenses.add(Expense.fromJson(doc.data));
      }
    }

    return expenses;
  }

  Future<List<Expense>> getAllExpensesByDateRange(String financeId,
      String branchName, String subBranchName, int start, int end) async {
    var expenseDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('expense_date', isGreaterThanOrEqualTo: start)
        .where('expense_date', isLessThanOrEqualTo: end)
        .orderBy('expense_date', descending: true)
        .getDocuments();

    List<Expense> expenses = [];
    if (expenseDocs.documents.isNotEmpty) {
      for (var doc in expenseDocs.documents) {
        expenses.add(Expense.fromJson(doc.data));
      }
    }

    return expenses;
  }

  Future<void> updateExpense(
      Expense expense, Map<String, dynamic> expenseJSON) async {
    expenseJSON['updated_at'] = DateTime.now();

    DocumentReference docRef = getDocumentReference(expense.financeID,
        expense.branchName, expense.subBranchName, expense.createdAt);

    int amount = 0;

    if (expenseJSON.containsKey('amount')) {
      amount = expense.amount - expenseJSON['amount'];
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

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);
              txUpdate(tx, docRef, expenseJSON);
            },
          );
        },
      );
    } catch (err) {
      print('Expense UPDATE Transaction failure:' + err.toString());
      throw err;
    }
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
                throw 'No Expense document found';
              }

              Expense expense = Expense.fromJson(snap.data);

              accData.cashInHand += expense.amount;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              txUpdate(tx, finDocRef, data);
              txDelete(tx, docRef);
            },
          );
        },
      );
    } catch (err) {
      print('Expense DELETE Transaction failure:' + err.toString());
      throw err;
    }
  }
}
