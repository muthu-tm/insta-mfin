import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/finance.dart';
import 'package:instamfin/db/models/subscriptions.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/finance/finance_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:instamfin/services/utils/response_utils.dart';

class UserController {
  Future<void> refreshUser(bool updatePref) async {
    if (cachedLocalUser.primary != null &&
        cachedLocalUser.primary.financeID != null &&
        cachedLocalUser.primary.financeID != "") {
      DocumentSnapshot snap =
          await cachedLocalUser.getFinanceDocReference().get();
      if (snap.exists) {
        Map<String, dynamic> doc = snap.data;
        if (!doc['is_active']) {
          emptyPrimary();
        } else {
          List<dynamic> admins = doc['admins'];
          if (!admins.contains(cachedLocalUser.getIntID())) {
            emptyPrimary();
          }

          if (updatePref) {
            cachedLocalUser.accPreferences =
                AccountPreferences.fromJson(doc['preferences']);
          }
        }
      } else {
        emptyPrimary();
      }
    }
  }

  emptyPrimary() {
    cachedLocalUser.primary.financeID = "";
    cachedLocalUser.primary.branchName = "";
    cachedLocalUser.primary.subBranchName = "";
  }

  Future<User> getUserByID(String number) async {
    try {
      if (number != null && number.trim() != "") {
        var userJSON = await User().getByID(number.trim());
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
      }, 'user');
      throw err;
    }
  }

  bool authCheck(String secretKey) {
    try {
      String hashKey =
          HashGenerator.hmacGenerator(secretKey, cachedLocalUser.getID());
      if (hashKey != cachedLocalUser.password) {
        return false;
      }

      return true;
    } catch (err) {
      throw err;
    }
  }

  Future updateUser(Map<String, dynamic> userJson) async {
    try {
      User user = User();
      user.mobileNumber = cachedLocalUser.mobileNumber;
      user.countryCode = cachedLocalUser.countryCode;
      var result = await user.update(userJson);

      AccountPreferences accPref = cachedLocalUser.accPreferences;
      int finValidTill = cachedLocalUser.financeSubscription;
      int chitValidTill = cachedLocalUser.chitSubscription;

      cachedLocalUser = User.fromJson(await user.getByID(user.getID()));

      cachedLocalUser.accPreferences = accPref;
      cachedLocalUser.financeSubscription = finValidTill;
      cachedLocalUser.chitSubscription = chitValidTill;

      return CustomResponse.getSuccesReponse(result);
    } catch (err) {
      Analytics.reportError({
        "type": 'user_update_error',
        "user_id": userJson['mobile_number'],
        'error': err.toString()
      }, 'user');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future<Finance> getPrimaryFinance() async {
    try {
      String primaryFinanceID = cachedLocalUser.primary.financeID;

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
          {"type": 'get_primary_error', 'error': err.toString()}, 'user');
      throw err;
    }
  }

  Future refreshCacheSubscription() async {
    try {
      if (cachedLocalUser.primary != null &&
          cachedLocalUser.primary.financeID != null &&
          cachedLocalUser.primary.financeID != "") {
        QuerySnapshot querySnap = await cachedLocalUser
            .getDocumentReference()
            .collection("subscriptions")
            .where('finance_id', isEqualTo: cachedLocalUser.primary.financeID)
            .getDocuments();
        int finSubscription;
        int chitSubscription;
        if (querySnap.documents.isNotEmpty) {
          List<DocumentSnapshot> docsSnap = querySnap.documents;
          for (int i = 0; i < docsSnap.length; i++) {
            Subscriptions sub = Subscriptions.fromJson(docsSnap[i].data);
            if (cachedLocalUser.primary.financeID == sub.financeID) {
              finSubscription = sub.finValidTill;
              chitSubscription = sub.chitValidTill;
            }
          }
        }

        cachedLocalUser.financeSubscription = finSubscription;
        cachedLocalUser.chitSubscription = chitSubscription;
      }
    } catch (err) {
      throw err;
    }
  }

  Future updatePrimaryFinance(
      String financeID, String branchName, String subBranchName) async {
    try {
      await cachedLocalUser.updatePrimaryDetails(financeID, branchName, subBranchName);

      cachedLocalUser.primary.financeID = financeID;
      cachedLocalUser.primary.branchName = branchName;
      cachedLocalUser.primary.subBranchName = subBranchName;

      await refreshCacheSubscription();
      await refreshUser(true);
    } catch (err) {
      Analytics.reportError({
        "type": 'update_primary_error',
        'user_id': cachedLocalUser.getID(),
        "finance_id": financeID,
        'branach_name': branchName,
        "sub_branch_name": subBranchName,
        'error': err.toString()
      }, 'user');
      throw err;
    }
  }

  Future getByMobileNumber(int mobileNumber, int countryCode) async {
    try {
      User user = User();
      user.mobileNumber = mobileNumber;
      user.countryCode = countryCode;
      var userJson = await user.getByID("");
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
      }, 'user');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateSecretKey(String key) async {
    try {
      String hashKey =
          HashGenerator.hmacGenerator(key, cachedLocalUser.getID());

      await cachedLocalUser
          .update({'password': hashKey, 'updated_at': DateTime.now()});

      cachedLocalUser.password = hashKey;

      return CustomResponse.getSuccesReponse("Successfully updated Secret KEY");
    } catch (err) {
      Analytics.reportError({
        "type": 'secret_update_error',
        'user_id': cachedLocalUser.getID(),
        'error': err.toString()
      }, 'user');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  Future updateTransactionSettings(
      Map<String, dynamic> userPref, Map<String, dynamic> accPref) async {
    try {
      await cachedLocalUser.update({'preferences': userPref});

      await cachedLocalUser
          .getFinanceDocReference()
          .updateData({'preferences': accPref});

      cachedLocalUser.preferences = UserPreferences.fromJson(userPref);
      cachedLocalUser.accPreferences = AccountPreferences.fromJson(accPref);

      return CustomResponse.getSuccesReponse(
          "Successfully updated preferences");
    } catch (err) {
      Analytics.reportError({
        "type": 'user_transaction_error',
        'user_id': cachedLocalUser.getID(),
        'error': err.toString()
      }, 'user');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
