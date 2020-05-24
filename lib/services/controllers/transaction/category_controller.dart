import 'package:instamfin/db/models/journal_category.dart';
import 'package:instamfin/db/models/miscellaneous_category.dart';
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
      print("Error while creating Journal category $name " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future createMiscellaneousCategory(String name, String notes) async {
    try {
      MiscellaneousCategory _mc = MiscellaneousCategory();
      _mc.setCategory(name);
      _mc.setNotes(notes);

      await _mc.create();

      return CustomResponse.getSuccesReponse(
          "Added new Miscellaneous Category $name successfully");
    } catch (err) {
      print("Error while creating Miscellaneous Category $name " +
          err.toString());
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
      print("Error while retrieving Journal Category: " + err.toString());
      throw err;
    }
  }

  Future<MiscellaneousCategory> getMiscellaneousCategoryByID(String financeId,
      String branchName, String subBranchName, DateTime createdAt) async {
    try {
      MiscellaneousCategory _mc = MiscellaneousCategory();
      Map<String, dynamic> mCategory = await _mc.getByID(
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return MiscellaneousCategory.fromJson(mCategory);
    } catch (err) {
      print("Error while retrieving Miscellaneous Category: " + err.toString());
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
      print("Error while retrieving Journal Categories: " + err.toString());
      throw err;
    }
  }

  Future<List<MiscellaneousCategory>> getAllMiscellaneousCategory(
      String financeId, String branchName, String subBranchName) async {
    try {
      List<MiscellaneousCategory> mCategories = await MiscellaneousCategory()
          .getAllCategories(financeId, branchName, subBranchName);

      if (mCategories == null) {
        return [];
      }

      return mCategories;
    } catch (err) {
      print(
          "Error while retrieving Miscellaneous Categories: " + err.toString());
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
      print("Error while editing Journal Category: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateMiscellaneousCategory(
      String financeId,
      String branchName,
      String subBranchName,
      DateTime createdAt,
      Map<String, dynamic> mcData) async {
    try {
      MiscellaneousCategory _mc = MiscellaneousCategory();

      await _mc.updateByID(mcData,
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Edited the Miscellaneous Category successfully");
    } catch (err) {
      print("Error while editing Miscellaneous Category: " + err.toString());
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
      print("Error while removing Journal Category: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future removeMiscellaneousCategory(String financeId, String branchName,
      String subBranchName, DateTime createdAt) async {
    try {
      MiscellaneousCategory _mc = MiscellaneousCategory();

      await _mc.delete(
          _mc.getDocumentID(financeId, branchName, subBranchName, createdAt));

      return CustomResponse.getSuccesReponse(
          "Removed the Miscellaneous Category successfully");
    } catch (err) {
      print("Error while remove Miscellaneous Category: " + err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
