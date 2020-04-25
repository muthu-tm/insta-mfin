import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class BranchController {
  SubBranchController _subBranchController = SubBranchController();

  Future addBranch(String financeID, String branchName, List<String> emails,
      Address address, DateTime dateOfRegistration, int addedBy) async {
    try {
      Branch newBranch = Branch();
      newBranch.setBranchName(branchName);
      newBranch.setDOR(dateOfRegistration);
      newBranch.setAddress(address);
      newBranch.addEmails(emails);
      newBranch.setAddedBy(addedBy);

      if (await newBranch.isExist(financeID, branchName)) {
        return CustomResponse.getFailureReponse(
            "Branch Name must be unique! A branch exists with the given Branch Name.");
      }

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

  Future<List<Branch>> getBranchesForUserID(
      String financeID, String userID) async {
    try {
      Branch branch = Branch();
      List<Branch> branches = await branch.getBranchByUserID(financeID, userID);

      if (branches == null) {
        return [];
      }

      return branches;
    } catch (err) {
      print("Error while retrieving branches for an user: " + userID);
      return null;
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

  Future updateBranch(String financeID, Branch branch) async {
    try {
      branch = await branch.update(financeID);

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
