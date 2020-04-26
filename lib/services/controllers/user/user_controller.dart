import 'package:instamfin/db/models/branch.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/sub_branch.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/finance/branch_controller.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/finance/sub_branch_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/response_utils.dart';

UserService _userService = locator<UserService>();

class UserController {
  FinanceController _financeController = FinanceController();
  BranchController _branchController = BranchController();
  SubBranchController _subBranchController = SubBranchController();

  User getCurrentUser() {
    return _userService.cachedUser;
  }

  int getCurrentUserID() {
    return _userService.cachedUser.mobileNumber;
  }

  Future<User> getUserByID(String number) async {
    try {
      if (number != null && number.trim() != "") {
        var userJSON = await User(int.parse(number)).getByID(number);
        if (userJSON != null) {
          User user = User.fromJson(userJSON);
          return user;
        } else {
          throw 'No User found for mobile number $number';
        }
      } else {
        throw 'Invalid UserID passed $number';
      }
    } catch (err) {
      throw err;
    }
  }

  Future replaceUser(User user) async {
    try {
      var result = await user.replace();

      _userService.setCachedUser(
          User.fromJson(await user.getByID(user.mobileNumber.toString())));

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateUser(Map<String, dynamic> userJson) async {
    try {
      User user = User(userJson['mobile_number']);
      var result = await user.update(userJson);

      _userService.setCachedUser(
          User.fromJson(await user.getByID(user.mobileNumber.toString())));

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Map<String, dynamic>> getPrimaryFinanceDetails() async {
    try {
      String primaryFinanceID = _userService.cachedUser.primaryFinance;
      String primaryBranchID = _userService.cachedUser.primaryBranch;
      String primarySubBranchID = _userService.cachedUser.primarySubBranch;

      Map<String, dynamic> result = new Map();

      if (primaryFinanceID != null && primaryFinanceID != "") {
        Finance finance =
            await _financeController.getFinanceByID(primaryFinanceID);
        if (finance != null) {
          result['finance_name'] = finance.financeName;
        }
      }
      if (primaryFinanceID != null &&
          primaryFinanceID != "" &&
          primaryBranchID != null &&
          primaryBranchID != "") {
        Branch branch = await _branchController.getBranchByID(
            primaryFinanceID, primaryBranchID);
        if (branch != null) {
          result['branch_name'] = branch.branchName;
        }
      }
      if (primaryFinanceID != null &&
          primaryFinanceID != "" &&
          primaryBranchID != null &&
          primaryBranchID != "" &&
          primarySubBranchID != null &&
          primarySubBranchID != "") {
        SubBranch subBranch = await _subBranchController.getSubBranchByID(
            primaryFinanceID, primaryBranchID, primarySubBranchID);
        if (subBranch != null) {
          result['sub_branch_name'] = subBranch.subBranchName;
        }
      }

      return result;
    } catch (err) {
      throw err;
    }
  }

  Future updatePrimaryFinance(int userNumber, String financeID, String branchID,
      String subBranchID) async {
    try {
      User user = User(userNumber);

      await user.update({
        'primary_finance': financeID,
        'primary_branch': branchID,
        'primary_sub_branch': subBranchID
      });

      _userService.cachedUser.primaryFinance = financeID;
      _userService.cachedUser.primaryBranch = branchID;
      _userService.cachedUser.primarySubBranch = subBranchID;
    } catch (err) {
      print('Error while updating Primary Finance for $userNumber.! ' +
          err.toString());
      throw err;
    }
  }

  Future getByMobileNumber(int mobileNumber) async {
    try {
      User user = User(mobileNumber);
      var userJson = await user.getByID(mobileNumber.toString());
      if (userJson == null) {
        return CustomResponse.getFailureReponse(
            "No user found for this mobile number!");
      }

      return CustomResponse.getSuccesReponse(userJson);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
