import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/notification/n_utils.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:instamfin/services/utils/response_utils.dart';

UserService _userService = locator<UserService>();

class UserController {
  User getCurrentUser() {
    return _userService.cachedUser;
  }

  UserPrimary getUserPrimary() {
    return _userService.cachedUser.primary;
  }

  int getCurrentUserID() {
    return _userService.cachedUser.mobileNumber;
  }

  Future<void> refreshUser() async {
    DocumentSnapshot snap =
        await _userService.cachedUser.getFinanceDocReference().get();
    if (snap.exists) {
      Map<String, dynamic> doc = snap.data;
      if (!doc['is_active']) {
        emptyPrimary();
      } else {
        List<dynamic> admins = doc['admins'];
        if (!admins.contains(getCurrentUserID())) {
          emptyPrimary();
        }
      }
    } else {
      emptyPrimary();
    }
  }

  emptyPrimary() {
    _userService.cachedUser.primary.financeID = "";
    _userService.cachedUser.primary.branchName = "";
    _userService.cachedUser.primary.subBranchName = "";
  }

  Future<User> getUserByID(String number) async {
    try {
      if (number != null && number.trim() != "") {
        var userJSON =
            await User(int.parse(number.trim())).getByID(number.trim());
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
      Analytics.reportError({
        "type": 'user_get_error',
        "user_id": number,
        'error': err.toString()
      });
      throw err;
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
      Analytics.reportError({
        "type": 'user_update_error',
        "user_id": userJson['mobile_number'],
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Finance> getPrimaryFinance() async {
    try {
      String primaryFinanceID = _userService.cachedUser.primary.financeID;

      if (primaryFinanceID != null && primaryFinanceID != "") {
        Finance finance =
            await FinanceController().getFinanceByID(primaryFinanceID);
        if (finance == null) {
          throw 'Unable to fetch Finance Details';
        }
        return finance;
      } else {
        return null;
      }
    } catch (err) {
      Analytics.reportError(
          {"type": 'get_primary_error', 'error': err.toString()});
      throw err;
    }
  }

  Future updatePrimaryFinance(int userNumber, String financeID,
      String branchName, String subBranchName) async {
    try {
      User user = User(userNumber);

      await user.update({
        'primary': {
          'finance_id': financeID,
          'branch_name': branchName,
          'sub_branch_name': subBranchName
        }
      });

      _userService.cachedUser.primary.financeID = financeID;
      _userService.cachedUser.primary.branchName = branchName;
      _userService.cachedUser.primary.subBranchName = subBranchName;

      NUtils.alertNotify(
          "", "PRIMARY FINANCE CHANGED", "Your Primary Finance modified...!");
    } catch (err) {
      Analytics.reportError({
        "type": 'update_primary_error',
        'user_id': userNumber,
        "finance_id": financeID,
        'branach_name': branchName,
        "sub_branch_name": subBranchName,
        'error': err.toString()
      });
      throw err;
    }
  }

  Future getByMobileNumber(int mobileNumber) async {
    try {
      User user = User(mobileNumber);
      var userJson = await user.getByID(mobileNumber.toString());
      // if (userJson == null) {
      //   Analytics.reportError({
      //     "type": 'user_get_error',
      //     'user_id': mobileNumber,
      //     'error': "No user found for this mobile number!"
      //   });
      //   return CustomResponse.getFailureReponse(
      //       "No user found for this mobile number!");
      // }

      return CustomResponse.getSuccesReponse(userJson);
    } catch (err) {
      Analytics.reportError({
        "type": 'user_get_error',
        'user_id': mobileNumber,
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateSecretKey(String key) async {
    try {
      String hashKey =
          HashGenerator.hmacGenerator(key, getCurrentUserID().toString());

      await getCurrentUser()
          .update({'password': hashKey, 'updated_at': DateTime.now()});

      _userService.cachedUser.password = hashKey;

      return CustomResponse.getSuccesReponse("Successfully updated Secret KEY");
    } catch (err) {
      Analytics.reportError({
        "type": 'secret_update_error',
        'user_id': getCurrentUserID(),
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateTransactionSettings(
      Map<String, dynamic> userPref, Map<String, dynamic> accPref) async {
    try {
      await getCurrentUser().update({'preferences': userPref});

      await getCurrentUser()
          .getFinanceDocReference()
          .updateData({'preferences': accPref});

      _userService.cachedUser.preferences = UserPreferences.fromJson(userPref);

      return CustomResponse.getSuccesReponse(
          "Successfully updated preferences");
    } catch (err) {
      Analytics.reportError({
        "type": 'user_transaction_error',
        'user_id': getCurrentUserID(),
        'error': err.toString()
      });
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
