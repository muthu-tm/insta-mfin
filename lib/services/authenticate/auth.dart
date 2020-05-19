import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamfin/services/analytics/user_analytics.dart';
import './../../db/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> registerWithMobileNumber(
      int mobileNumber, String password, String name) async {
    try {
      User user = User(mobileNumber);
      var data = await user.getByID(mobileNumber.toString());
      if (data != null) {
        print("Found an existing user for this mobile number");
        return null;
      }

      user.setPassword(password);
      user.setName(name);
      await user.create();

      UserAnalytics.signupEvent(mobileNumber.toString());
      return User.fromJson(await user.getByID(mobileNumber.toString()));
    } catch (err) {
      UserAnalytics.reportError({"type": 'sign_up_error', "user_id": mobileNumber, 'name': name, 'error': err.toString()});
      print(err.toString());
      throw err;
    }
  }

  Future<User> signInWithMobileNumber(int mobileNumber, String passkey) async {
    try {
      User user = User(mobileNumber);
      var data = await user.getByID(mobileNumber.toString());
      if (data == null) {
        throw ("No users found for this mobile number");
        // return null;
      }

      if (data["password"] == passkey) {
        print("Successful login");
        UserAnalytics.loginEvent(mobileNumber.toString());
        return User.fromJson(data);
      } else {
        UserAnalytics.reportError({"type": 'log_in_error', "user_id": mobileNumber, 'is_success': false, 'error': 'Wrong Password!'});
        throw ("Wrong password! Pease try again");
        // return null;
      }
    } catch (err) {
      UserAnalytics.reportError({"type": 'log_in_error',  "user_id": mobileNumber, 'is_success': false, 'error': err.toString()});
      print(err.toString());
      throw err;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      UserAnalytics.sendAnalyticsEvent(
          'sign_out_error', {'error': err.toString()});
      print(err.toString());
      throw err;
    }
  }
}
