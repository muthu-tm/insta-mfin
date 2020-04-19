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

  Future updateBranchAdmins(
      List<int> userList, String financeID, String branchName) async {
    try {
      Branch branch = Branch();
      await branch
          .updateArrayField({'admins': userList, 'users': userList}, financeID, branchName);

      List<SubBranch> subBranches =
          await getAllSubBranches(financeID, branchName);
      await updateSubBranchAdmins(subBranches, userList, financeID, branchName);

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<void> updateSubBranchAdmins(List<SubBranch> subBranches,
      List<int> userList, String financeID, String branchName) async {
    
    if (subBranches != null) {
      for (var index = 0; index < subBranches.length; index++) {
        SubBranch subBranch = subBranches[index];
        String subBranchName = subBranch.subBranchName;

        await _subBranchController.updateSubBranchAdmins(
            userList, financeID, branchName, subBranchName);
      }
    }
  }

  Future getBranchByUserID(String financeID, String userID) async {
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
      print("Error while retrieving sub braches for Branch: " + branchName);
      return null;
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
