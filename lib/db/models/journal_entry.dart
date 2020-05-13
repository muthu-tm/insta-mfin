import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/model.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'journal_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalEntry extends Model {

  static CollectionReference _miscellaneousCollRef =
      Model.db.collection("journal_entries");

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

  JournalEntry();

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

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);

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
              int inHandAmount = doc.data['cash_in_hand'];
              int journalIn = doc.data['journal_in'];
              int journalOut = doc.data['journal_out'];

              Map<String, dynamic> data = Map();

              if (this.isExpense) {
                data['cash_in_hand'] = inHandAmount - this.amount;
                data['journal_out'] = journalOut + this.amount;
                data['journal_in'] = journalIn;
              } else {
                data['cash_in_hand'] = inHandAmount + this.amount;
                data['journal_in'] = journalIn + this.amount;
              }

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
      print('Transaction success!');
    } catch (err) {
      print('Transaction failure:' + err.toString());
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

  Future<List<JournalEntry>> getAllJournals(
      String financeId, String branchName, String subBranchName) async {
    QuerySnapshot snapDocs = await getCollectionRef()
        .where('finance_id', isEqualTo: financeId)
        .where('branch_name', isEqualTo: branchName)
        .where('sub_branch_name', isEqualTo: subBranchName)
        .getDocuments();

    if (snapDocs.documents.isEmpty) {
      return [];
    }

    List<JournalEntry> expenses = [];
    snapDocs.documents.forEach((e) {
      expenses.add(JournalEntry.fromJson(e.data));
    });

    return expenses;
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
              int inHandAmount = doc.data['cash_in_hand'];
              int journalIn = doc.data['journal_in'];
              int journalOut = doc.data['journal_out'];

              Map<String, dynamic> data = Map();

              DocumentSnapshot snap = await tx.get(docRef);

              if (!snap.exists) {
                throw 'No Journal document found';
              }

              JournalEntry journal = JournalEntry.fromJson(snap.data);

              if (journal.isExpense) {
                data['cash_in_hand'] = inHandAmount + journal.amount;
                data['journal_out'] = journalOut - journal.amount;
              } else {
                data['cash_in_hand'] = inHandAmount - journal.amount;
                data['journal_in'] = journalIn - journal.amount;
              }

              // Update finance details
              txUpdate(tx, finDocRef, data);
              // Remove Journal
              txDelete(
                  tx,
                  this.getDocumentReference(
                      financeID, branchName, subBranchName, createdAt));
            },
          );
        },
      );
      print('Transaction success!');
    } catch (err) {
      print('Transaction failure:' + err.toString());
    }
  }
}
