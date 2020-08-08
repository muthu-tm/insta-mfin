import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/expense_category.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class CategoryController {
  Future createJournalCategory(String name, String notes) async {
    try {
      JournalCategory _jc = JournalCategory();
      _jc.setCategory(name);
      _jc.setNotes(notes);

      await _jc.create();

      return CustomResponse.getSuccesReponse(
          "Added new Journal Category $name successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_journal_create_error',
        'cat_name': name,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future createExpenseCategory(String name, String notes) async {
    try {
      ExpenseCategory _mc = ExpenseCategory();
      _mc.setCategory(name);
      _mc.setNotes(notes);

      await _mc.create();

      return CustomResponse.getSuccesReponse(
          "Added new Expense Category $name successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_expense_create_error',
        'cat_name': name,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<JournalCategory> getJournalCategoryByID(String financeId,
      String branchName, String subBranchName, DateTime createdAt) async {
    try {
      JournalCategory _jc = JournalCategory();
      Map<String, dynamic> jCategory = await _jc.getByID(
          _jc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return JournalCategory.fromJson(jCategory);
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_journal_get_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      throw err;
    }
  }

  Future<ExpenseCategory> getExpenseCategoryByID(String financeId,
      String branchName, String subBranchName, DateTime createdAt) async {
    try {
      ExpenseCategory _mc = ExpenseCategory();
      Map<String, dynamic> mCategory = await _mc.getByID(
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return ExpenseCategory.fromJson(mCategory);
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_expense_get_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      throw err;
    }
  }

  Future<List<JournalCategory>> getAllJournalCategory(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<JournalCategory> jCategories = await JournalCategory()
          .getAllCategories(financeId, branchName, subBranchName);

      if (jCategories == null) {
        return [];
      }

      return jCategories;
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_journal_getall_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      throw err;
    }
  }

  Future<List<ExpenseCategory>> getAllExpenseCategory(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<ExpenseCategory> mCategories = await ExpenseCategory()
          .getAllCategories(financeId, branchName, subBranchName);

      if (mCategories == null) {
        return [];
      }

      return mCategories;
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_expense_getall_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      throw err;
    }
  }

  Future updateJournalCategory(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime createdAt,
      Map<String, dynamic> jcData) async {
    try {
      JournalCategory _jc = JournalCategory();

      await _jc.updateByID(jcData,
          _jc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Edited the Journal Category successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_journal_update_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateExpenseCategory(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime createdAt,
      Map<String, dynamic> mcData) async {
    try {
      ExpenseCategory _mc = ExpenseCategory();

      await _mc.updateByID(mcData,
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Edited the Expense Category successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_expense_update_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeJournalCategory(
    String financeId,
    String branchName,
    String subBranchName,
    DateTime createdAt,
  ) async {
    try {
      JournalCategory _jc = JournalCategory();

      await _jc.delete(
          _jc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Removed the Journal Category successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_journal_remove_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeExpenseCategory(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      ExpenseCategory _mc = ExpenseCategory();

      await _mc.delete(
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Removed the Expense Category successfully");
    } catch (err) {
      Analytics.reportError({
        "type": 'cat_expense_remove_error',
        'finance_id': financeId,
        'error': err.toString()
      }, 'categories');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
