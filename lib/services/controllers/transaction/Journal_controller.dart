import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/journal_entry.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class JournalController {
  Future createNewJournal(String name, int amount, JournalCategory category,
      bool isExpense, DateTime date, String notes) async {
    try {
      JournalEntry _je = JournalEntry();
      _je.setJournalName(name);
      _je.setAmount(amount);
      _je.setCategory(category);
      _je.setIsExpense(isExpense);
      _je.setJournalDate(date);
      _je.setNotes(notes);

      await _je.create();

      return CustomResponse.getSuccesReponse(
          "Added new Journal Entry $name successfully");
    } catch (err) {
      print("Error while creating Journal Entry $name " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<JournalEntry>> getAllJournalEntries(
      String financeId, String branchName, String subBranchName) {
    try {
      JournalEntry _je = JournalEntry();
      return _je.getAllJournals(financeId, branchName, subBranchName);
    } catch (err) {
      print("Error while retrieving Journal Entries: " + err.toString());
      throw err;
    }
  }

  Future<List<JournalEntry>> getAllJournalByDateRage(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<JournalEntry> journals = await JournalEntry()
          .getAllJournalsByDateRage(
              financeId, branchName, subBranchName, startDate, endDate);

      if (journals == null) {
        return [];
      }

      return journals;
    } catch (err) {
      print(
          "Error while retrieving journals with Date Range: " + err.toString());
      throw err;
    }
  }

  Future<List<int>> getTotalJournalAmount(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<JournalEntry> journals =
          await getAllJournalEntries(financeId, branchName, subBranchName);

      int inTotal = 0;
      int outTotal = 0;
      journals.forEach(
        (journal) {
          if (journal.isExpense) {
            outTotal += journal.amount;
          } else {
            inTotal += journal.amount;
          }
        },
      );

      return [inTotal, outTotal];
    } catch (err) {
      print("Error while retrieving Total Miscellaneous Expense amount: " +
          err.toString());
      throw err;
    }
  }

  Future<JournalEntry> getJournalEntryByID(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      JournalEntry _je = JournalEntry();
      Map<String, dynamic> jEntry = await _je.getByID(
          _je.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return JournalEntry.fromJson(jEntry);
    } catch (err) {
      print("Error while retrieving Journal Entry: " + err.toString());
      throw err;
    }
  }

  Future updateJournalEntry(
      JournalEntry journal,
      Map<String, dynamic> jeData) async {
    try {
      JournalEntry _je = JournalEntry();

      await _je.updateJournal(journal, jeData);

      return CustomResponse.getSuccesReponse(
          "Updated Journal Entry successfully");
    } catch (err) {
      print("Error while editing Journal Entry: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeJournalEntry(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      JournalEntry _je = JournalEntry();

      await _je.removeJournal(financeId, branchName, subBranchName, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed the Journal Entry successfully");
    } catch (err) {
      print("Error while removing Journal Entry: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
