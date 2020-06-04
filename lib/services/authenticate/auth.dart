import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  Future signOut() async {
    try {
      await _auth.signOut();
      final SharedPreferences prefs = await _prefs;
      await prefs.remove("mobile_number");
      return;
    } catch (err) {
      Analytics.sendAnalyticsEvent('sign_out_error', {'error': err.toString()});
      throw err;
    }
  }
}
