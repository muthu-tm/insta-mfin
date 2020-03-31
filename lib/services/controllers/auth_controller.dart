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

      //Create an user document in User collection
      await user.create();

      return userObj['id'];
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
