import 'package:firebase_auth/firebase_auth.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/db/models/user_primary.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<User> registerWithMobileNumber(int mobileNumber, int countryCode,
      String password, String name, String uid) async {
    try {
      User user = User();
      user.mobileNumber = mobileNumber;
      user.countryCode = countryCode;
      user.setName(name);
      user.setGuid(uid);
      String hKey = HashGenerator.hmacForSecretKey(password, user.getID());
      user.setPassword(hKey);
      user.setPreferences(UserPreferences.fromJson(UserPreferences().toJson()));
      user.setPrimary(UserPrimary.fromJson(UserPrimary().toJson()));
      user.address = Address.fromJson(Address().toJson());
      user = await user.create();

      Analytics.signupEvent(user.getID());
      return user;
    } catch (err) {
      Analytics.reportError({
        "type": 'sign_up_error',
        "user_id": countryCode.toString() + mobileNumber.toString(),
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
