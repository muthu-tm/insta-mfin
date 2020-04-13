import 'package:firebase_auth/firebase_auth.dart';
import './../../db/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> registerWithMobileNumber(int mobileNumber, String password, String name) async {
     try {
      User user = User(mobileNumber);
      var data = await user.getByID();
      if (data != null) {
        print("Found an existing user for this mobile number");
        return null;
      }

      user.setPassword(password);
      user.setName(name);
      await user.create();

      return user ??= User.fromJson(await user.getByID());
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future<User> signInWithMobileNumber(int mobileNumber, String passkey) async{
    try {
      User user = User(mobileNumber);
      var data = await user.getByID();
      if (data == null) {
        throw ("No users found for this mobile number");
        // return null;
      }

      if (data["password"] == passkey) {
        print("Successful login");
        return User.fromJson(data);
      } else {
        throw ("Wrong password! Pease try again");
        // return null; 
      }

    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }


}
