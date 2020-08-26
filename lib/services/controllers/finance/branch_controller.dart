import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/notification/n_utils.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class BranchController {
  Future addBranch(String financeID, String branchName, String contactNumber,
      String email, Address address, int dateOfRegistration) async {
    try {

      Branch newBranch = Branch();
      if (await newBranch.isExist(financeID, branchName)) {
        Analytics.reportError({
          "type": 'branch_create_error',
          "finance_id": financeID,
          'branach_name': branchName,
          'error':
              "Branch Name must be unique! A branch exists with the given Branch Name."
        }, 'branch');
        return CustomResponse.getFailureReponse(
            "Branch Name must be unique! A branch exists with the given Branch Name.");
      }

      newBranch.setBranchName(branchName);
      newBranch.setDOR(dateOfRegistration);
      newBranch.setEmail(email);
      newBranch.setContactNumber(contactNumber);
      newBranch.setAddress(address);

      FinanceController _financeController = FinanceController();
      List<int> admins = await _financeController.getAllAdmins(financeID);
      newBranch.addAdmins(admins);
      newBranch.setAddedBy(cachedLocalUser.getIntID());

      Branch branch = await newBranch.create(financeID);

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_create_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateBranchAdmins(bool isAdd, List<int> userList, String financeID,
      String branchName, bool notify) async {
    try {
      Branch branch = Branch();
      await branch.updateArrayField(isAdd,
          {'admins': userList, 'users': userList}, financeID, branchName);

      List<SubBranch> subBranches =
          await getAllSubBranches(financeID, branchName);
      if (subBranches != null && subBranches.length > 0) {
        await updateSubBranchAdmins(
            isAdd, subBranches, userList, financeID, branchName);
      }

      if (notify && isAdd) {
        userList.forEach((u) {
          NUtils.userNotify(
              "",
              "Branch Admin",
              "You have been added as an ADMIN for the Branch '$branchName'. Please change your primary finance to work with this Branch. Thanks!",
              u);
        });
      } else if (notify && !isAdd) {
        userList.forEach((u) {
          NUtils.userNotify(
              "",
              "Branch Admin",
              "Your access to the Branch '$branchName' has been revoked. Thanks!",
              u);
        });
      }

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_admin_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "is_add": isAdd,
        'error': err.toString()
      }, 'branch');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateBranchUsers(bool isAdd, List<int> userList, String financeID,
      String branchName) async {
    try {
      Branch branch = Branch();
      await branch.updateArrayField(
          isAdd, {'users': userList}, financeID, branchName);

      FinanceController _financeController = FinanceController();
      await _financeController.updateFinanceUsers(isAdd, userList, financeID);

      return CustomResponse.getSuccesReponse(
          "Successfully updated Users list of Branch $branchName");
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_user_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "is_add": isAdd,
        'error': err.toString()
      }, 'branch');
      throw err;
    }
  }

  Future<void> updateSubBranchAdmins(bool isAdd, List<SubBranch> subBranches,
      List<int> userList, String financeID, String branchName) async {
    if (subBranches != null) {
      for (var index = 0; index < subBranches.length; index++) {
        SubBranch subBranch = subBranches[index];
        String subBranchName = subBranch.subBranchName;

        await SubBranchController().updateSubBranchAdmins(
            isAdd, userList, financeID, branchName, subBranchName, false);
      }
    }
  }

  Future<Branch> getBranchByName(String financeID, String branchName) async {
    try {
      Branch branch = Branch();
      return await branch.getBranchByName(financeID, branchName);
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_get_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      throw err;
    }
  }

  Future<List<SubBranch>> getAllSubBranches(
      String financeID, String branchName) async {
    try {
      List<SubBranch> subBranches =
          await SubBranch().getAllSubBranches(financeID, branchName);

      if (subBranches == null) {
        return [];
      }

      return subBranches;
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_subbranch_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      throw err;
    }
  }

  Future<List<Branch>> getBranchesForUserID(
      String financeID, int userID) async {
    try {
      Branch branch = Branch();
      List<Branch> branches = await branch.getBranchByUserID(financeID, userID);

      if (branches == null) {
        return [];
      }

      return branches;
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_for_user_error',
        "finance_id": financeID,
        'user_id': userID,
        'error': err.toString()
      }, 'branch');
      return null;
    }
  }

  Future<List<int>> getAllAdmins(String financeID, String branchName) async {
    try {
      Branch branch = await getBranchByName(financeID, branchName);

      if (branch == null) {
        throw 'No data found for this $branchName';
      }

      return branch.admins;
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_get_admin_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      throw err;
    }
  }

  Future<bool> isUserAdmin(
      String financeID, String branchName, int userID) async {
    try {
      List<int> admins = await getAllAdmins(financeID, branchName);

      if (admins.contains(userID)) {
        return true;
      }

      return false;
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_check_admin_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      throw err;
    }
  }

  Future updateBranch(String financeID, String branchName,
      Map<String, dynamic> branchJSON) async {
    try {
      await Branch().update(financeID, branchName, branchJSON);

      return CustomResponse.getSuccesReponse("Updated Branch $branchName");
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_update_error',
        "finance_id": financeID,
        'branach_name': branchName,
        'error': err.toString()
      }, 'branch');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
