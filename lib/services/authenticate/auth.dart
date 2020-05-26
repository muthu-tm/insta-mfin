import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/db/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> registerWithMobileNumber(
      int mobileNumber, String password, String name) async {
    try {
      User user = User(mobileNumber);
      var data = await user.getByID(mobileNumber.toString());
      if (data != null) {
        Analytics.reportError({
          "type": 'sign_up_error',
          "user_id": mobileNumber,
          'name': name,
          'error': "Found an existing user for this mobile number"
        });
        return null;
      }

      user.setPassword(password);
      user.setName(name);
      await user.create();

      Analytics.signupEvent(mobileNumber.toString());
      return User.fromJson(await user.getByID(mobileNumber.toString()));
    } catch (err) {
      Analytics.reportError({
        "type": 'sign_up_error',
        "user_id": mobileNumber,
        'name': name,
        'error': err.toString()
      });
      throw err;
    }
  }

  Future<User> signInWithMobileNumber(int mobileNumber, String passkey) async {
    try {
      User user = User(mobileNumber);
      var data = await user.getByID(mobileNumber.toString());
      if (data == null) {
        throw ("No users found for this mobile number");
      }

      if (data["password"] == passkey) {
        Analytics.loginEvent(mobileNumber.toString());
        return User.fromJson(data);
      } else {
        throw ("Wrong password! Pease try again");
      }
    } catch (err) {
      Analytics.reportError({
        "type": 'log_in_error',
        "user_id": mobileNumber,
        'is_success': false,
        'error': err.toString()
      });
      throw err;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      Analytics.sendAnalyticsEvent('sign_out_error', {'error': err.toString()});
      throw err;
    }
  }
}
