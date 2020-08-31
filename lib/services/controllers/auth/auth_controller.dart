import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/fcm/user_token.dart';
import 'package:instamfin/services/utils/response_utils.dart';
import 'package:instamfin/services/authenticate/auth.dart';

class AuthController {
  AuthService _authService = AuthService();

  dynamic registerWithMobileNumber(int mobileNumber, int countryCode,
      String passkey, String userName, String uid) async {
    try {
      User user = await _authService.registerWithMobileNumber(
          mobileNumber, countryCode, passkey, userName, uid);

      var platformData = await UserFCM().getPlatformDetails();

      if (platformData != null) {
        user.updatePlatformDetails({"platform_data": platformData});
      } else {
        Analytics.reportError({
          "type": 'platform_update_error',
          "user_id": user.getID(),
          'name': userName,
          'error': "Unable to update User's platform details"
        }, 'platform_update');
      }

      user.update({'last_signed_in_at': DateTime.now()});
      user.setLastSignInTime(DateTime.now());

      // cache the user data
      cachedLocalUser = user;

      return CustomResponse.getSuccesReponse(user.toJson());
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  dynamic signInWithMobileNumber(User user) async {
    try {
      var platformData = await UserFCM().getPlatformDetails();

      if (platformData != null) {
        user.updatePlatformDetails({"platform_data": platformData});
      } else {
        Analytics.reportError({
          "type": 'platform_update_error',
          "user_id": user.getID(),
          'error': "Unable to update User's platform details"
        }, 'platform_update');
      }

      Analytics.loginEvent(user.getID());

      // update cloud firestore "users" collection
      user.update({'last_signed_in_at': DateTime.now()});

      // cache the user data
      cachedLocalUser = user;

      return CustomResponse.getSuccesReponse(user);
    } catch (err) {
      Analytics.reportError({
        "type": 'log_in_error',
        "user_id": user.getID(),
        'name': user.name,
        'error': err.toString()
      }, 'log_in');
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  dynamic signOut() async {
    try {
      await _authService.signOut();

      return CustomResponse.getSuccesReponse("Successfully signed out");
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }
}
