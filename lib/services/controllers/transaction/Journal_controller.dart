import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/journal.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
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
      Analytics.reportError({
        "type": 'journal_create_error',
        'error': err.toString()
      }, 'journal');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<Journal>> getAllJournalEntries(
      String financeId, String branchName, String subBranchName) {
    try {
      Journal _je = Journal();
      return _je.getAllJournals(financeId, branchName, subBranchName);
    } catch (err) {
      Analytics.reportError({
        "type": 'journal_get_all_error',
        'error': err.toString()
      }, 'journal');
      throw err;
    }
  }

  Future<List<Journal>> getJournalByDate(
      String financeId, String branchName, String subBranchName, DateTime date) async {
    try {
      List<Journal> journals = await Journal().getAllJournalsByDate(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(date));

      if (journals == null) {
        return [];
      }

      return journals;
    } catch (err) {
      Analytics.reportError({
        "type": 'journal_get_date_error',
        'error': err.toString()
      }, 'journal');
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
      Analytics.reportError({
        "type": 'journal_get_week_error',
        'error': err.toString()
      }, 'journal');
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
      Analytics.reportError({
        "type": 'journal_get_month_error',
        'error': err.toString()
      }, 'journal');
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
      Analytics.reportError({
        "type": 'journal_get_range_error',
        'error': err.toString()
      }, 'journal');
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
      Analytics.reportError({
        "type": 'journal_get_error',
        'error': err.toString()
      }, 'journal');
      throw err;
    }
  }

  Future removeJournal(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      await Journal().removeJournal(financeId, branchName, subBranchName, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed the Journal successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'journal_remove_error',
        'error': err.toString()
      }, 'journal');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
