import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class JournalController {
  Future createNewJournal(String name, int amount, JournalCategory category,
      bool isExpense, int date, String notes) async {
    try {
      Journal _je = Journal();
      _je.setJournalName(name);
      _je.setAmount(amount);
      _je.setCategory(category);
      _je.setIsExpense(isExpense);
      _je.setJournalDate(date);
      _je.setNotes(notes);

      await _je.create();

      return CustomResponse.getSuccesReponse(
          "Added new Journal $name successfully");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<Journal>> getAllJournalEntries(
      String financeId, String branchName, String subBranchName) {
    try {
      Journal _je = Journal();
      return _je.getAllJournals(financeId, branchName, subBranchName);
    } catch (err) {
      print("Error while retrieving Journals: " + err.toString());
      throw err;
    }
  }

  Future<List<Journal>> getTodaysExpenses(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<Journal> journals = await Journal().getAllJournalsByDate(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(DateUtils.getCurrentDate()));

      if (journals == null) {
        return [];
      }

      return journals;
    } catch (err) {
      throw err;
    }
  }

  Future<List<Journal>> getThisWeekExpenses(
      String financeId, String branchName, String subBranchName) async {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllJournalByDateRange(financeId, branchName, subBranchName,
          today.subtract(Duration(days: today.weekday)), today);
    } catch (err) {
      throw err;
    }
  }

  Future<List<Journal>> getThisMonthExpenses(
      String financeId, String branchName, String subBranchName) async {
    try {
      DateTime today = DateUtils.getCurrentDate();

      return getAllJournalByDateRange(financeId, branchName, subBranchName,
          DateTime(today.year, today.month, 1, 0, 0, 0, 0), today);
    } catch (err) {
      throw err;
    }
  }

  Future<List<Journal>> getAllJournalByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<Journal> journals = await Journal().getAllJournalsByDateRange(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(startDate),
          DateUtils.getUTCDateEpoch(endDate));

      if (journals == null) {
        return [];
      }

      return journals;
    } catch (err) {
      throw err;
    }
  }

  Future<List<int>> getTotalJournalAmount(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<Journal> journals =
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
      throw err;
    }
  }

  Future<Journal> getJournalByID(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      Journal _je = Journal();
      Map<String, dynamic> jEntry = await _je.getByID(
          _je.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return Journal.fromJson(jEntry);
    } catch (err) {
      throw err;
    }
  }

  Future updateJournal(Journal journal, Map<String, dynamic> jeData) async {
    try {
      // Journal _je = Journal();

      // await _je.updateJournal(journal, jeData);

      return CustomResponse.getSuccesReponse("Updated Journal successfully");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeJournal(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      Journal _je = Journal();

      await _je.removeJournal(financeId, branchName, subBranchName, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed the Journal successfully");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
