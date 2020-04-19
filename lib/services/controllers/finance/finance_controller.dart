import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class FinanceController {
  UserController _userController = UserController();
  BranchController _branchController = BranchController();

  Future createFinance(String name, String registeredID, List<String> emails,
      Address address, DateTime dateOfRegistration, int addedBy) async {
    try {
      Finance financeCompany = Finance();
      financeCompany.setFianceName(name);
      financeCompany.setRegistrationID(registeredID);
      financeCompany.setAddress(address);
      financeCompany.addEmails(emails);
      financeCompany.addAdmins([addedBy]);
      financeCompany.setAddedBy(addedBy);

      financeCompany = await financeCompany.create();

      _userController.updatePrimaryFinance(addedBy,
          financeCompany.createdAt.millisecondsSinceEpoch.toString(), "", "");

      return CustomResponse.getSuccesReponse(financeCompany.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future getFinanceByUserID(String userID) async {
    try {
      Finance finance = Finance();
      List<Finance> finances = await finance.getFinanceByUserID(userID);

      if (finances == null) {
        return [];
      }

      return finances;
    } catch (err) {
      print("Error while retrieving finace for an user: " + userID);
      return null;
    }
  }

  Future addAdmins(List<int> userList, String financeID) async {
    try {
      Finance finance = Finance();
      await finance.updateArrayField({'admins': userList, 'users': userList}, financeID);

      List<Branch> branches = await getAllBranches(financeID);
      await updateBranchAdmins(branches, userList, financeID);

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<void> updateBranchAdmins(
      List<Branch> branches, List<int> userList, String financeID) async {
    if (branches != null) {
      for (var index = 0; index < branches.length; index++) {
        Branch branch = branches[index];
        String branchName = branch.branchName;

        await _branchController.updateBranchAdmins(
            userList, financeID, branchName);
      }
    }
  }

  Future<List<Branch>> getAllBranches(String financeID) async {
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

  Future updateCompany(Finance finance) async {
    try {
      finance = await finance.replace();

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
