import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/response_utils.dart';
import './../../authenticate/auth.dart';

UserService _userService = locator<UserService>();

class AuthController {
  AuthService _authService = AuthService();

  dynamic registerWithMobileNumber(
      int mobileNumber, String passkey, String userName) async {
    try {
      User user = await _authService.registerWithMobileNumber(
          mobileNumber, passkey, userName);

      if (user == null) {
        return CustomResponse.getFailureReponse(
            "Found an existing user for this mobile number");
      }

      user.update({'last_signed_in_at': DateTime.now()});

      // cache the user data
      _userService.setCachedUser(user);

      return CustomResponse.getSuccesReponse(user);
    } catch (err) {
      return CustomResponse.getFailureReponse(err.toString());
    }
  }

  dynamic signInWithMobileNumber(int mobileNumber, String passkey) async {
    try {
      User user =
          await _authService.signInWithMobileNumber(mobileNumber, passkey);

      // update cloud firestore "users" collection
      user.update({'last_signed_in_at': DateTime.now()});

      // cache the user data
      _userService.setCachedUser(user);

      return CustomResponse.getSuccesReponse(user);
    } catch (err) {
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
