import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class BranchController {
  Future addNewBranch(String financeID, String branchName, List<String> emails,
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

  Future<List<Branch>> getBranchesForFinance(String financeID) async {
    try {
      List<Branch> branches = await Branch().getAllBranches(financeID);

      if (branches == null) {
        return [];
      }
      
      return branches;
    } catch (err) {
      print("Error while retrieving braches for ID: " + financeID);
      return null;
    }
  }

  Future updateCompany(String financeID, Branch branch) async {
    try {
      branch = await branch.update(financeID);

      return CustomResponse.getSuccesReponse(branch.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
