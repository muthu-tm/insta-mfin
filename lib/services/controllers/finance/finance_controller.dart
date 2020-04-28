import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class FinanceController {
  BranchController _branchController = BranchController();

  Future createFinance(String name, String registeredID, String contactNumber,
      String email, Address address, String dateOfRegistration) async {
    try {
      UserController _userController = UserController();
      int addedBy = _userController.getCurrentUserID();

      Finance financeCompany = Finance();
      financeCompany.setFianceName(name);
      financeCompany.setRegistrationID(registeredID);
      financeCompany.setAddress(address);
      financeCompany.setContactNumber(contactNumber);
      financeCompany.setDOR(dateOfRegistration);
      financeCompany.setEmail(email);
      financeCompany.addAdmins([addedBy]);
      financeCompany.addUsers([addedBy]);

      financeCompany = await financeCompany.create();

      await _userController.updatePrimaryFinance(addedBy,
          financeCompany.createdAt.millisecondsSinceEpoch.toString(), "", "");

      return CustomResponse.getSuccesReponse(financeCompany.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<List<Finance>> getFinanceByUserID(int userID) async {
    try {
      Finance finance = Finance();
      List<Finance> finances = await finance.getFinanceByUserID(userID);

      if (finances == null) {
        return [];
      }

      return finances;
    } catch (err) {
      print(
          "Error while retrieving finace for user $userID: " + err.toString());
      return null;
    }
  }

  Future<Finance> getFinanceByID(String financeID) async {
    try {
      Finance finance = Finance();
      var financeData = await finance.getByID(financeID);
      if (financeData == null) {
        throw 'No Finance found for this ID $financeID';
      }
      return Finance.fromJson(financeData);
    } catch (err) {
      print("Error while fetching Finance using financeID: " + err.toString());
      throw err;
    }
  }

  Future<String> getFinanceName(String financeID) async {
    try {
      var financeData = await Finance().getByID(financeID);
      if (financeData == null) {
        throw 'No Finance found for this ID $financeID';
      }
      return financeData['finance_name'];
    } catch (err) {
      print("Error while fetching Finance using financeID: " + err.toString());
      return "";
    }
  }

  Future updateFinanceAdmins(
      bool isAdd, List<int> userList, String financeID) async {
    try {
      Finance finance = Finance();
      await finance.updateArrayField(
          isAdd, {'admins': userList, 'users': userList}, financeID);

      List<Branch> branches = await getAllBranches(financeID);
      if (branches != null && branches.length > 0) {
        await updateBranchAdmins(isAdd, branches, userList, financeID);
      }

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      print("Error while updating Admins for Finance $financeID: " +
          err.toString());
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateFinanceUsers(
      bool isAdd, List<int> userList, String financeID) async {
    try {
      Finance finance = Finance();
      await finance.updateArrayField(isAdd, {'users': userList}, financeID);

      return CustomResponse.getSuccesReponse(
          "Successfully updated Users list of Finance $financeID");
    } catch (err) {
      print("Error while updating Finance User for $financeID: " +
          err.toString());
      throw err;
    }
  }

  Future<void> updateBranchAdmins(bool isAdd, List<Branch> branches,
      List<int> userList, String financeID) async {
    if (branches != null) {
      for (var index = 0; index < branches.length; index++) {
        Branch branch = branches[index];
        String branchName = branch.branchName;

        await _branchController.updateBranchAdmins(
            isAdd, userList, financeID, branchName);
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
      throw err;
    }
  }

  Future<List<int>> getAllAdmins(String financeID) async {
    try {
      Finance finance = await getFinanceByID(financeID);

      if (finance == null) {
        return [];
      }

      return finance.admins;
    } catch (err) {
      print("Error while retrieving braches for ID: " + financeID);
      throw err;
    }
  }

  Future<bool> isUserAdmin(String financeID, int userID) async {
    try {
      List<int> admins = await getAllAdmins(financeID);

      if (admins.contains(userID)) {
        return true;
      }

      return false;
    } catch (err) {
      print("Error while validating Finance user $userID: " + err.toString());
      throw err;
    }
  }

  Future updateFinance(
      Map<String, dynamic> financeJson, String financeID) async {
    try {
      Finance finance = Finance();
      var result = await finance.updateByID(financeJson, financeID);

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future replaceFinanceData(Finance finance) async {
    try {
      finance = await finance.replace();

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
