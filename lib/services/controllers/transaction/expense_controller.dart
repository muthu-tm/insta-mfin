import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/db/models/expense.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class ExpenseController {
  Future createNewExpense(String name, int amount, ExpenseCategory category,
      int date, String notes) async {
    try {
      Expense _me = Expense();
      _me.setExpenseName(name);
      _me.setAmount(amount);
      _me.setCategory(category);
      _me.setExpenseDate(date);
      _me.setNotes(notes);

      await _me.create();

      return CustomResponse.getSuccesReponse(
          "Added new Expense $name successfully");
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_create_error', 'error': err.toString()}, 'expense');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<Expense>> getExpenseByDate(String financeId, String branchName,
      String subBranchName, DateTime date) async {
    try {
      List<Expense> expenses = await Expense().getAllExpensesByDate(financeId,
          branchName, subBranchName, DateUtils.getUTCDateEpoch(date));

      if (expenses == null) {
        return [];
      }

      return expenses;
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_get_date_error', 'error': err.toString()},
          'expense');
      throw err;
    }
  }

  Future<List<Expense>> getThisWeekExpenses(
      String financeId, String branchName, String subBranchName) {
    try {
      DateTime today = DateTime.now();

      return getAllExpenseByDateRange(financeId, branchName, subBranchName,
          today.subtract(Duration(days: today.weekday)), today);
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_get_week_error', 'error': err.toString()},
          'expense');
      throw err;
    }
  }

  Future<List<Expense>> getThisMonthExpenses(
      String financeId, String branchName, String subBranchName) {
    try {
      DateTime today = DateTime.now();

      return getAllExpenseByDateRange(financeId, branchName, subBranchName,
          DateTime(today.year, today.month, 1, 0, 0, 0, 0), today);
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_get_month_error', 'error': err.toString()},
          'expense');
      throw err;
    }
  }

  Future<List<Expense>> getAllExpenseByDateRange(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime startDate,
      DateTime endDate) async {
    try {
      List<Expense> expenses = await Expense().getAllExpensesByDateRange(
          financeId,
          branchName,
          subBranchName,
          DateUtils.getUTCDateEpoch(startDate),
          DateUtils.getUTCDateEpoch(endDate));

      if (expenses == null) {
        return [];
      }

      return expenses;
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_get_range_error', 'error': err.toString()},
          'expense');
      throw err;
    }
  }

  Future<Expense> getExpenseByID(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      Expense _me = Expense();
      Map<String, dynamic> mExpense = await _me.getByID(
          _me.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return Expense.fromJson(mExpense);
    } catch (err) {
      Analytics.reportError(
          {"type": 'expense_get_id_error', 'error': err.toString()}, 'expense');
      throw err;
    }
  }

  Future updateExpense(Expense expense, Map<String, dynamic> meData) async {
    try {
      await Expense().updateExpense(expense, meData);

      return CustomResponse.getSuccesReponse("Updated Expense successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'expense_update_error',
        'expense_id': expense.getID(),
        'error': err.toString()
      }, 'expense');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeExpense(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      await Expense()
          .removeExpense(financeId, branchName, subBranchName, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed the Expense successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'expense_remove_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'expense');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
