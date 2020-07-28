import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/notification/n_utils.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class FinanceController {
  Future createFinance(String name, String registeredID, String contactNumber,
      String email, Address address, int dateOfRegistration) async {
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
      financeCompany.setAddedBy(addedBy);
      financeCompany.addUsers([addedBy]);

      financeCompany = await financeCompany.create();

      await _userController.updatePrimaryFinance(
          financeCompany.createdAt.millisecondsSinceEpoch.toString(), "", "");

      NUtils.financeNotify("", "NEW FINANCE",
          "Hurray! Created a new Finance $name in iFIN. All the Best!");

      NUtils.userNotify(
          "",
          "NEW FINANCE",
          "Hurray! Your have created a Finance $name in iFIN. We wish 'All the Best' for your Business!",
          addedBy);

      return CustomResponse.getSuccesReponse(financeCompany.toJson());
    } catch (err) {
      Analytics.reportError({
        "type": 'finance_create_error',
        "finance_name": name,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_get_error',
        "user_id": userID,
        'error': err.toString()
      });
      return null;
    }
  }

  Future<Finance> getFinanceByID(String financeID) async {
    try {
      if (financeID == "") {
        throw 'Please set a valid Finance as Primary!';
      }

      Finance finance = Finance();
      var financeData = await finance.getByID(financeID);
      if (financeData == null) {
        throw 'No Finance found for this ID $financeID';
      }
      return Finance.fromJson(financeData);
    } catch (err) {
      Analytics.reportError({
        "type": 'finance_get_error',
        "finance_id": financeID,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_get_error',
        "user_id": financeID,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_admin_error',
        "is_add": isAdd,
        "finance_id": financeID,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_user_error',
        "is_add": isAdd,
        "finance_id": financeID,
        'error': err.toString()
      });
      throw err;
    }
  }

  Future<void> updateBranchAdmins(bool isAdd, List<Branch> branches,
      List<int> userList, String financeID) async {
    if (branches != null) {
      BranchController _branchController = BranchController();
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
      Analytics.reportError({
        "type": 'finance_branch_error',
        "finance_id": financeID,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_admin_error',
        "finance_id": financeID,
        'error': err.toString()
      });
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
      Analytics.reportError({
        "type": 'finance_check_admin_error',
        "finance_id": financeID,
        'error': err.toString()
      });
      throw err;
    }
  }

  Future updateFinance(
      Map<String, dynamic> financeJson, String financeID) async {
    try {
      var result = await Finance().updateByID(financeJson, financeID);

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      Analytics.reportError({
        "type": 'finance_update_error',
        "finance_id": financeID,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
