import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class BranchController {
  SubBranchController _subBranchController = SubBranchController();

  Future addBranch(String financeID, String branchName, String contactNumber,
      String email, Address address, String dateOfRegistration) async {
    try {
      Branch newBranch = Branch();
      if (await newBranch.isExist(financeID, branchName)) {
        return CustomResponse.getFailureReponse(
            "Branch Name must be unique! A branch exists with the given Branch Name.");
      }
      UserController _userController = UserController();
      int addedBy = _userController.getCurrentUserID();

      FinanceController _financeController = FinanceController();
      newBranch.setBranchName(branchName);
      newBranch.setDOR(dateOfRegistration);
      newBranch.setEmail(email);
      newBranch.setContactNumber(contactNumber);
      newBranch.setAddress(address);

      List<int> admins = await _financeController.getAllAdmins(financeID);
      newBranch.addAdmins(admins);
      newBranch.setAddedBy(addedBy);

      Branch branch = await newBranch.create(financeID);
      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateBranchAdmins(bool isAdd, List<int> userList, String financeID,
      String branchName) async {
    try {
      Branch branch = Branch();
      await branch.updateArrayField(isAdd,
          {'admins': userList, 'users': userList}, financeID, branchName);

      List<SubBranch> subBranches =
          await getAllSubBranches(financeID, branchName);
      await updateSubBranchAdmins(
          isAdd, subBranches, userList, financeID, branchName);

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<void> updateSubBranchAdmins(bool isAdd, List<SubBranch> subBranches,
      List<int> userList, String financeID, String branchName) async {
    if (subBranches != null) {
      for (var index = 0; index < subBranches.length; index++) {
        SubBranch subBranch = subBranches[index];
        String subBranchName = subBranch.subBranchName;

        await _subBranchController.updateSubBranchAdmins(
            isAdd, userList, financeID, branchName, subBranchName);
      }
    }
  }

  Future<Branch> getBranchByID(String financeID, String branchID) async {
    try {
      Branch branch = Branch();
      return await branch.getBranchByID(financeID, branchID);
    } catch (err) {
      print("Error while retrieving branch for BranchID: " + branchID);
      return null;
    }
  }

  Future<Branch> getBranchByName(String financeID, String branchName) async {
    try {
      Branch branch = Branch();
      return await branch.getBranchByName(financeID, branchName);
    } catch (err) {
      print("Error while retrieving branch for Branch: " + branchName);
      throw err;
    }
  }

  Future<List<SubBranch>> getAllSubBranches(
      String financeID, String branchName) async {
    try {
      List<SubBranch> subBranches =
          await SubBranch().getAllSubBranches(financeID, branchName);

      if (subBranches == null) {
        throw 'No SubBranches for $branchName';
      }

      return subBranches;
    } catch (err) {
      print("Error while retrieving sub braches for Branch: " + branchName);
      throw err;
    }
  }

  Future<List<Branch>> getBranchesForUserID(String financeID, int userID) async {
    try {
      Branch branch = Branch();
      List<Branch> branches = await branch.getBranchByUserID(financeID, userID);

      if (branches == null) {
        return [];
      }

      return branches;
    } catch (err) {
      print("Error while retrieving branch for user $userID: " + err.toString());
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
      print("Error while retrieving data for Branch: " + branchName);
      throw err;
    }
  }

  Future<bool> isUserAdmin(String financeID, String branchName, int userID) async {
    try {
      List<int> admins = await getAllAdmins(financeID, branchName);

      if (admins.contains(userID)) {
        return true;
      }

      return false;
    } catch (err) {
      print("Error while validating Branch user $userID: " + err.toString());
      throw err;
    }
  }

  Future updateBranch(String financeID, String branchName, Map<String, dynamic>  branchJSON) async {
    try {
      await Branch().update(financeID, branchName, branchJSON);

      return CustomResponse.getSuccesReponse("Updated Branch $branchName");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
