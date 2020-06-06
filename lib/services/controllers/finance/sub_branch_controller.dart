import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/notification/n_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class SubBranchController {
  Future addSubBranch(
      String financeID,
      String branchName,
      String subBranchName,
      String contactNumber,
      String email,
      Address address,
      String dateOfRegistration) async {
    try {
      SubBranch newSubBranch = SubBranch();
      if (await newSubBranch.isExist(financeID, branchName, subBranchName)) {
        Analytics.reportError({
          "type": 'finance_create_error',
          "finance_id": financeID,
          "branch_name": branchName,
          "sub_branch_name": subBranchName,
          'error':
              "Branch Name must be unique! A subBranch exists with the given Branch Name."
        });
        return CustomResponse.getFailureReponse(
            "Branch Name must be unique! A subBranch exists with the given Branch Name.");
      }

      BranchController _branchController = BranchController();
      UserController _userController = UserController();
      int addedBy = _userController.getCurrentUserID();

      newSubBranch.setSubBranchName(subBranchName);
      newSubBranch.setDOR(dateOfRegistration);
      newSubBranch.setAddress(address);
      newSubBranch.setContactNumber(contactNumber);
      newSubBranch.setEmail(email);

      List<int> admins =
          await _branchController.getAllAdmins(financeID, branchName);
      newSubBranch.addAdmins(admins);
      newSubBranch.setAddedBy(addedBy);

      SubBranch subBranch = await newSubBranch.create(financeID, branchName);

      NUtils.financeNotify("", "NEW Branch",
          "Woww! Your have grown your business. Our Best wishes to exapnd more! We are ready to provide more OFFERS, Please Contact Us");

      return CustomResponse.getSuccesReponse(subBranch.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'sub_branch_create_error',
        "finance_id": financeID,
        "branch_name": branchName,
        "sub_branch_name": subBranchName,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateSubBranchAdmins(bool isAdd, List<int> userList, String financeID,
      String branchName, String subBranchName) async {
    try {
      SubBranch subBranch = SubBranch();
      await subBranch.updateArrayField(
          isAdd, {'admins': userList}, financeID, branchName, subBranchName);

      NUtils.financeNotify("", "New SubBranch Admin",
          "You have added new Admin for the SubBranch $subBranchName");

      userList.forEach((u) {
        NUtils.userNotify(
            "",
            "SubBranch Admin",
            "You have added as a Admin for the SubBranch $subBranchName of Branch $branchName. Please change your primary finance to work with this SubBranch. Thanks!",
            u);
      });

      return CustomResponse.getSuccesReponse(
          "Successfully updated Admin list of SubBranch $subBranchName");
    } catch (err) {
      Analytics.reportError({
        "type": 'sub_branch_admin_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "sub_branch_name": subBranchName,
        "is_add": isAdd,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<SubBranch>> getSubBranchesForUserID(
      String financeID, String branchName, int userID) async {
    try {
      SubBranch subBranch = SubBranch();
      List<SubBranch> subBranches =
          await subBranch.getSubBranchByUserID(financeID, branchName, userID);

      if (subBranches == null) {
        return [];
      }

      return subBranches;
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_get_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "user_id": userID,
        'error': err.toString()
      });
      return null;
    }
  }

  Future<SubBranch> getSubBranchByID(
      String financeID, String branchName, String subBranchID) async {
    try {
      return await SubBranch()
          .getSubBranchByID(financeID, branchName, subBranchID);
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_get_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "sub_branch_id": subBranchID,
        'error': err.toString()
      });
      return null;
    }
  }

  Future updateSubBranch(String financeID, String branchName,
      String subBranchName, Map<String, dynamic> subBranchJSON) async {
    try {
      await SubBranch()
          .update(financeID, branchName, subBranchName, subBranchJSON);

      return CustomResponse.getSuccesReponse(
          "Successfully updated the subBranch $subBranchName");
    } catch (err) {
      Analytics.reportError({
        "type": 'branch_update_error',
        "finance_id": financeID,
        'branach_name': branchName,
        "sub_branch_name": subBranchName,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
