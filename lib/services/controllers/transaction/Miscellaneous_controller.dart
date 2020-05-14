import 'package:instamfin/db/models/miscellaneous_category.dart';
import 'package:instamfin/db/models/miscellaneous_expense.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class MiscellaneousController {
  Future createNewExpense(String name, int amount,
      MiscellaneousCategory category, DateTime date, String notes) async {
    try {
      MiscellaneousExpense _me = MiscellaneousExpense();
      _me.setExpenseName(name);
      _me.setAmount(amount);
      _me.setCategory(category);
      _me.setExpenseDate(date);
      _me.setNotes(notes);

      await _me.create();

      return CustomResponse.getSuccesReponse(
          "Added new Miscellaneous Expense $name successfully");
    } catch (err) {
      print(
          "Error while creating Miscellaneous Expense $name " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<MiscellaneousExpense>> getAllMiscellaneous(
      String financeId, String branchName, String subBranchName) {
    try {
      MiscellaneousExpense _me = MiscellaneousExpense();
      return _me.getAllExpenses(financeId, branchName, subBranchName);
    } catch (err) {
      print("Error while retrieving Miscellaneous Expenses: " + err.toString());
      throw err;
    }
  }

  Future<int> getTotalExpenseAmount(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<MiscellaneousExpense> expenses =
          await getAllMiscellaneous(financeId, branchName, subBranchName);
      int total = 0;
      expenses.forEach((expense) {
        total += expense.amount;
      });

      return total;
    } catch (err) {
      print("Error while retrieving Total Miscellaneous Expense amount: " +
          err.toString());
      throw err;
    }
  }

  Future<MiscellaneousExpense> getMiscellaneousExpenseByID(String financeId,
      String branchName, String subBranchName, DateTime createdAt) async {
    try {
      MiscellaneousExpense _me = MiscellaneousExpense();
      Map<String, dynamic> mExpense = await _me.getByID(
          _me.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return MiscellaneousExpense.fromJson(mExpense);
    } catch (err) {
      print("Error while retrieving Miscellaneous Expense: " + err.toString());
      throw err;
    }
  }

  Future editJournalEntry(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime createdAt,
      Map<String, String> meData) async {
    try {
      MiscellaneousExpense _me = MiscellaneousExpense();

      await _me.updateByID(meData,
          _me.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Edited the Miscellaneous Expense successfully");
    } catch (err) {
      print("Error while editing Miscellaneous Expense: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeMiscellaneousExpense(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      MiscellaneousExpense _me = MiscellaneousExpense();

      await _me.removeExpense(financeId, branchName, subBranchName, createdAt);

      return CustomResponse.getSuccesReponse(
          "Removed the Miscellaneous Expense successfully");
    } catch (err) {
      print("Error while removing Miscellaneous Expense: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
