import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<User> registerWithMobileNumber(
      int mobileNumber, String password, String name, String uid) async {
    try {
      User user = User(mobileNumber);
      var data = await user.getByID(mobileNumber.toString());
      if (data != null) {
        Analytics.reportError({
          "type": 'sign_up_error',
          "user_id": mobileNumber,
          'name': name,
          'error': "Found an existing user for this mobile number"
        }, 'sign_up');
        return null;
      }

      String hKey =
          HashGenerator.hmacGenerator(password, user.mobileNumber.toString());
      user.setPassword(hKey);
      user.setName(name);
      user.setGuid(uid);
      user.setPreferences(UserPreferences.fromJson(UserPreferences().toJson()));
      user.setPrimary(UserPrimary.fromJson(UserPrimary().toJson()));
      user = await user.create();

      Analytics.signupEvent(mobileNumber.toString());
      return user;
    } catch (err) {
      Analytics.reportError({
        "type": 'sign_up_error',
        "user_id": mobileNumber,
        'name': name,
        'error': err.toString()
      }, 'sign_up');
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
      Analytics.reportError({
        "type": 'sign_out_error',
        "error": err.toString(),
      }, 'sign_out');
      throw err;
    }
  }
}
