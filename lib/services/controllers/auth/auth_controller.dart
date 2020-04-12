import 'package:instamfin/db/models/user.dart';
import './../../authenticate/auth.dart';

class AuthController {
  AuthService _authService = AuthService();

  dynamic registerWithMobileNumber(int mobileNumber, String passkey, String userName) async {
    try {
      User user = await _authService.registerWithMobileNumber(
          mobileNumber, passkey, userName);

      if (user == null) {
        return {
          'is_registered': false,
          "error_code": 1,
          'message': "Found an existing user for this mobile number"
        };
      }

      user.update({'last_signed_in_at': DateTime.now()});

      // set user global state
      await user.setUserState();

      return {
        'is_registered': true,
        "error_code": 0,
        'message': user
      };
    } catch (err) {
      return {
        'is_registered': false,
        // "error_code": err.code,
        "message": err.toString()
      };
    }
  }

  dynamic signInWithMobileNumber(int mobileNumber, String passkey) async {
    try {
       User user = await _authService.signInWithMobileNumber(mobileNumber, passkey);

      // update cloud firestore "users" collection
      user.update({'last_signed_in_at': DateTime.now()});
      await user.setUserState();

      return {
        'is_logged_in': true,
        "error_code": 0,
        'message': user
      };
    } catch (err) {
      return {
        'is_logged_in': false,
        // "error_code": err.code,
        "message": err.toString()
      };
    }
  }

  dynamic signOut() async {
    try {
      return await _authService.signOut();

      // return {
      //   'is_signed_out': true,
      //   "error_code": 0,
      //   "message": "Successfully signed out!"
      // };
    } catch (err) {
      // return {
      //   'is_signed_out': false,
      //   // "error_code": err.code,
      //   "message": err.message
      // };
      return null;
    }
  }

}
