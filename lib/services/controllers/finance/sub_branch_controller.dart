import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class SubBranchController {
  Future addSubBranch(
      String financeID,
      String branchName,
      String subBranchName,
      List<String> emails,
      Address address,
      DateTime dateOfRegistration,
      int addedBy) async {
    try {
      SubBranch newSubBranch = SubBranch();
      newSubBranch.setSubBranchName(subBranchName);
      newSubBranch.setDOR(dateOfRegistration);
      newSubBranch.setAddress(address);
      newSubBranch.addEmails(emails);
      newSubBranch.setAddedBy(addedBy);

      if (await newSubBranch.isExist(financeID, branchName, subBranchName)) {
        return CustomResponse.getFailureReponse(
            "Branch Name must be unique! A subBranch exists with the given Branch Name.");
      }

      SubBranch subBranch = await newSubBranch.create(financeID, branchName);
      return CustomResponse.getSuccesReponse(subBranch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateSubBranchAdmins(List<int> userList, String financeID,
      String branchName, String subBranchName) async {
    try {
      SubBranch subBranch = SubBranch();
      await subBranch.updateArrayField(
          {'admins': userList, 'users': userList}, financeID, branchName, subBranchName);

      return CustomResponse.getSuccesReponse(subBranch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateSubBranch(
      String financeID, String branchName, SubBranch subBranch) async {
    try {
      subBranch = await subBranch.update(financeID, branchName);

      return CustomResponse.getSuccesReponse(subBranch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
