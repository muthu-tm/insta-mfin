import './../authenticate/auth.dart';
import 'package:instamfin/models/user.dart';

class AuthController {
  AuthService _authService = AuthService();

  dynamic registerUserWithEmailPassword(
      emailID, passkey, userName, mobileNumber) async {
    try {
      var userObj =
          await _authService.registerWithEmailPassword(emailID, passkey);

      User user = User(userObj['id'], userObj['email']);
      user.setPassword(passkey);
      user.setName(userName);
      user.setMobileNumber(int.parse(mobileNumber));
      user.setLastSignInTime(userObj['last_signed_in_at']);

      //Create an user document in User collection
      await user.create();

      return {
        'is_registered': true,
        "error_code": 0,
        'message': {'id': userObj['id'], 'name': userName, 'email': emailID}
      };
    } catch (err) {
      return {
        'is_registered': false,
        "error_code": err.code,
        "message": err.message
      };
    }
  }

  dynamic signInWithEmailPassword(String emailID, String passkey) async {
    try {
      var userObj =
          await _authService.signInWithEmailPassword(emailID, passkey);

      User user = User(userObj['id'], userObj['email']);
      user.update(
          userObj['id'], {'last_signed_in_at': userObj['last_signed_in_at']});

      return {
        'is_logged_in': true,
        "error_code": 0,
        'message': {
          'id': userObj['id'],
          'email': userObj['email'],
          "is_email_verified": userObj['is_email_verified'],
          "created_at": userObj['created_at']
        }
      };
    } catch (err) {
      return {
        'is_logged_in': false,
        "error_code": err.code,
        "message": err.message
      };
    }
  }

  dynamic signOut() async {
    try {
      await _authService.signOut();

      return {
        'is_signed_out': true,
        "error_code": 0,
        "message": "Successfully signed out!"
      };
    } catch (err) {
      return {
        'is_signed_out': false,
        "error_code": err.code,
        "message": err.message
      };
    }
  }
}
