import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class FinanceController {
  BranchController _branchController = BranchController();

  Future createFinance(String name, String registeredID, List<String> emails,
      Address address, DateTime dateOfRegistration, int addedBy) async {
    try {
      UserController _userController = UserController();
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

  Future<Finance> getFinanceByID(String financeID) async{
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

  Future updateFinanceAdmins(
      bool isAdd, List<int> userList, String financeID) async {
    try {
      Finance finance = Finance();
      await finance.updateArrayField(
          isAdd, {'admins': userList, 'users': userList}, financeID);

      List<Branch> branches = await getAllBranches(financeID);
      await updateBranchAdmins(isAdd, branches, userList, financeID);

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
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

  Future updateCompany(Finance finance) async {
    try {
      finance = await finance.replace();

      return CustomResponse.getSuccesReponse(finance.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
