import 'package:instamfin/services/utils/users_utils.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:instamfin/db/models/user.dart' as fb;
import 'package:instamfin/db/sqlite/sql_users.dart';
import './../../authenticate/auth.dart';

class AuthController {
  AuthService _authService = AuthService();
  UserDao _userDao = UserDao(database);

  dynamic registerUserWithEmailPassword(
      emailID, passkey, userName, mobileNumber) async {
    try {
      var userObj =
          await _authService.registerWithEmailPassword(emailID, passkey);

      fb.User user = fb.User(userObj['email']);
      user.setUserID(userObj['id']);
      user.setPassword(passkey);
      user.setName(userName);
      user.setMobileNumber(int.parse(mobileNumber));
      user.setLastSignInTime(userObj['last_signed_in_at']);
      user.setCloudProfilePath("");
      user.setLocalProfilePath("");

      //Create an user document in User collection
      await user.create();
      await _userDao.insertUser(user.toJson());

      await user.setGlobalUserState(emailID);
      await _userDao.setUserState(emailID);

      return {
        'is_registered': true,
        "error_code": 0,
        'message': {'id': userObj['id'], 'name': userName, 'email': emailID}
      };
    } catch (err) {
      return {
        'is_registered': false,
        // "error_code": err.code,
        "message": err.message
      };
    }
  }

  dynamic signInWithEmailPassword(String emailID, String passkey) async {
    try {
      var userObj = await _userDao.getUserByEmail(emailID);

      if (userObj == null) {
        userObj = await _authService.signInWithEmailPassword(emailID, passkey);
        print("New USER fetched from FireBase successfully --> " + userObj.toString());

        await _userDao.insertUser(userObj);
      }

      fb.User user = fb.User(userObj['email']);

      // update cloud firestore "users" collection
      user.update(userObj['email'], {'last_signed_in_at': DateTime.now().toString()});
      // update sqlite usign Moor ORM
      _userDao.updateByEmailID(
          UserModelCompanion(
              lastSignInTime: Value(DateTime.now().toString()),
              updatedAt: Value(DateTime.now().toString())),
          userObj['email']);

      UserUtils.setUserState(userObj);
      
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
        // "error_code": err.code,
        "message": err.message
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

  Future<int> deleteAllUsers() async {
    try {
      return await _userDao.deleteUserData();
    } catch (err) {
      print("Error occurred while reoving all users: " + err.toString());
      return 0;
    }
  }
}
