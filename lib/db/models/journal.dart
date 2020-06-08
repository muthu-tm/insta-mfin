import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/accounts_data.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal.g.dart';

@JsonSerializable(explicitToJson: true)
class Journal extends Model {
  static CollectionReference _miscellaneousCollRef =
      Model.db.collection("journals");

  @JsonKey(name: 'finance_id', nullable: true)
  String financeID;
  @JsonKey(name: 'branch_name', nullable: true)
  String branchName;
  @JsonKey(name: 'sub_branch_name', nullable: true)
  String subBranchName;
  @JsonKey(name: 'journal_name')
  String journalName;
  @JsonKey(name: 'category', nullable: true)
  JournalCategory category;
  @JsonKey(name: 'amount', nullable: true)
  int amount;
  @JsonKey(name: 'journal_date')
  DateTime journalDate;
  @JsonKey(name: 'is_expense', defaultValue: false)
  bool isExpense;
  @JsonKey(name: 'added_by', nullable: true)
  int addedBy;
  @JsonKey(name: 'notes', defaultValue: '')
  String notes;
  @JsonKey(name: 'created_at', nullable: true)
  DateTime createdAt;
  @JsonKey(name: 'updated_at', nullable: true)
  DateTime updatedAt;

  Journal();

  setFinanceID(String financeID) {
    this.financeID = financeID;
  }

  setBranchName(String branchName) {
    this.branchName = branchName;
  }

  setSubBranchName(String subBranchName) {
    this.subBranchName = subBranchName;
  }

  setJournalName(String name) {
    this.journalName = name;
  }

  setCategory(JournalCategory category) {
    this.category = category;
  }

  setAmount(int amount) {
    this.amount = amount;
  }

  setJournalDate(DateTime journalDate) {
    this.journalDate = journalDate;
  }

  setIsExpense(bool isExpense) {
    this.isExpense = isExpense;
  }

  setAddedBy(int mobileNumber) {
    this.addedBy = mobileNumber;
  }

  setNotes(String notes) {
    this.notes = notes;
  }

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
  Map<String, dynamic> toJson() => _$JournalToJson(this);

  CollectionReference getCollectionRef() {
    return _miscellaneousCollRef;
  }

  String getID() {
    String value = this.financeID + this.branchName + this.subBranchName;
    return HashGenerator.hmacGenerator(
        value, this.createdAt.millisecondsSinceEpoch.toString());
  }

  Query getGroupQuery() {
    return Model.db.collectionGroup('journals');
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

              if (this.isExpense) {
                accData.cashInHand -= this.amount;
                accData.journalOutAmount += this.amount;
                accData.journalOut += 1;
              } else {
                accData.cashInHand += this.amount;
                accData.journalInAmount += this.amount;
                accData.journalIn += 1;
              }

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
      print('Journal CREATE Transaction success!');
    } catch (err) {
      print('Journal CREATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Stream<QuerySnapshot> streamJournals(
      String financeId, String branchName, String subBranchName) {
    return getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .snapshots();
  }

  Future<List<Journal>> getAllJournals(
      String financeId, String branchName, String subBranchName) async {
    QuerySnapshot snapDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .getDocuments();

    if (snapDocs.documents.isEmpty) {
      return [];
    }

    List<Journal> expenses = [];
    snapDocs.documents.forEach((e) {
      expenses.add(Journal.fromJson(e.data));
    });

    return expenses;
  }

  Future<List<Journal>> getAllJournalsByDateRage(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime start,
      DateTime end) async {
    var journalDocs = await getGroupQuery()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .where('journal_date', isGreaterThanOrEqualTo: start)
        .where('journal_date', isLessThan: end)
        .getDocuments();

    List<Journal> journals = [];
    if (journalDocs.documents.isNotEmpty) {
      for (var doc in journalDocs.documents) {
        journals.add(Journal.fromJson(doc.data));
      }
    }

    return journals;
  }

  Future<void> updateJournal(
      Journal journal, Map<String, dynamic> journalJSON) async {
    journalJSON['updated_at'] = DateTime.now();

    DocumentReference docRef = getDocumentReference(journal.financeID,
        journal.branchName, journal.subBranchName, journal.createdAt);

    int amount = 0;
    int journalInAmount = 0;
    int journalOutAmount = 0;
    if (journalJSON.containsKey('is_expense') && journal.isExpense) {
      // journal type change from Expense to Income
      if (journalJSON.containsKey('amount')) {
        amount = journalJSON['amount'] + journal.amount;
        journalInAmount = journalJSON['amount'];
      } else {
        amount = journal.amount * 2;
        journalInAmount = journal.amount;
      }
      journalOutAmount -= journal.amount;
    } else if (journalJSON.containsKey('is_expense') && !journal.isExpense) {
      // journal type change from Income to Expense
      if (journalJSON.containsKey('amount')) {
        amount -= (journalJSON['amount'] + journal.amount);
        journalOutAmount = journalJSON['amount'];
      } else {
        amount -= (journal.amount * 2);
        journalOutAmount = journal.amount;
      }
      journalInAmount -= journal.amount;
    } else if (journalJSON.containsKey('amount') && journal.isExpense) {
      // Out amount change
      amount = journal.amount - journalJSON['amount'];
      journalOutAmount = journalJSON['amount'] - journal.amount;
    } else if (journalJSON.containsKey('amount') && !journal.isExpense) {
      // IN amount change
      amount = journalJSON['amount'] - journal.amount;
      journalInAmount = journalJSON['amount'] - journal.amount;
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
              accData.journalOutAmount += journalOutAmount;
              accData.journalInAmount += journalInAmount;

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              // Update finance details
              txUpdate(tx, finDocRef, data);

              // Remove Payment
              txUpdate(tx, docRef, journalJSON);
            },
          );
        },
      );
    } catch (err) {
      print('Journal UPDATE Transaction failure:' + err.toString());
      throw err;
    }
  }

  Future removeJournal(String financeID, String branchName,
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
                throw 'No Journal document found';
              }

              Journal journal = Journal.fromJson(snap.data);

              if (journal.isExpense) {
                accData.cashInHand += journal.amount;
                accData.journalOutAmount -= journal.amount;
                accData.journalOut -= 1;
              } else {
                accData.cashInHand -= journal.amount;
                accData.journalInAmount -= journal.amount;
                accData.journalIn -= 1;
              }

              Map<String, dynamic> data = {'accounts_data': accData.toJson()};
              // Update finance details
              txUpdate(tx, finDocRef, data);

              // Remove Journal
              txDelete(tx, docRef);
            },
          );
        },
      );

      print('Journal DELETE Transaction success!');
    } catch (err) {
      print('Journal DELETE Transaction failure:' + err.toString());
      throw err;
    }
  }
}
