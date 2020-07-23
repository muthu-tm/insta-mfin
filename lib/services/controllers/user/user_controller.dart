import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
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

  Future<void> refreshUser(bool updatePref) async {
    if (_userService.cachedUser.primary != null &&
        _userService.cachedUser.primary.financeID != null &&
        _userService.cachedUser.primary.financeID != "") {
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

          if (updatePref) {
            _userService.cachedUser.accPreferences =
                AccountPreferences.fromJson(doc['preferences']);
          }
        }
      } else {
        emptyPrimary();
      }
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

      AccountPreferences accPref = getCurrentUser().accPreferences;
      int finValidTill = getCurrentUser().financeSubscription;
      int chitValidTill = getCurrentUser().chitSubscription;

      _userService.setCachedUser(
          User.fromJson(await user.getByID(user.mobileNumber.toString())));

      _userService.cachedUser.accPreferences = accPref;
      _userService.cachedUser.financeSubscription = finValidTill;
      _userService.cachedUser.chitSubscription = chitValidTill;

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

  Future refreshCacheSubscription() async {
    try {
      if (_userService.cachedUser.primary != null &&
          _userService.cachedUser.primary.financeID != null &&
          _userService.cachedUser.primary.financeID != "") {
        QuerySnapshot querySnap = await _userService.cachedUser
            .getDocumentReference()
            .collection("subscriptions")
            .where('finance_id',
                isEqualTo: _userService.cachedUser.primary.financeID)
            .getDocuments();
        int finSubscription;
        int chitSubscription;
        if (querySnap.documents.isNotEmpty) {
          List<DocumentSnapshot> docsSnap = querySnap.documents;
          for (int i = 0; i < docsSnap.length; i++) {
            Subscriptions sub = Subscriptions.fromJson(docsSnap[i].data);
            if (_userService.cachedUser.primary.financeID == sub.financeID) {
              finSubscription = sub.finValidTill;
              chitSubscription = sub.chitValidTill;
            }
          }
        }

        _userService.cachedUser.financeSubscription = finSubscription;
        _userService.cachedUser.chitSubscription = chitSubscription;
      }
    } catch (err) {
      throw err;
    }
  }

  Future updatePrimaryFinance(
      String financeID, String branchName, String subBranchName) async {
    try {
      User user = User(_userService.cachedUser.mobileNumber);

      await user.updatePrimaryDetails(_userService.cachedUser.mobileNumber,
          _userService.cachedUser.guid, financeID, branchName, subBranchName);

      _userService.cachedUser.primary.financeID = financeID;
      _userService.cachedUser.primary.branchName = branchName;
      _userService.cachedUser.primary.subBranchName = subBranchName;

      await refreshCacheSubscription();
      await refreshUser(true);
    } catch (err) {
      Analytics.reportError({
        "type": 'update_primary_error',
        'user_id': _userService.cachedUser.mobileNumber,
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
      _userService.cachedUser.accPreferences =
          AccountPreferences.fromJson(accPref);

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
