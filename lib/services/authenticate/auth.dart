import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import './../../db/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(String user) {
    Map userMap = jsonDecode(user);
    return User.fromJson(userMap);
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user.toString()));
  }

  Future signInWithEmailPassword(String emailID, String passkey) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: emailID, password: passkey);
      FirebaseUser fbUser = result.user;

      User user = User(fbUser.email);
      Map<String, dynamic> userMap = await user.getByID(fbUser.email);

      return userMap;
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  Future registerWithEmailPassword(String emailID, String passkey) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: emailID, password: passkey);

      FirebaseUser user = result.user;
      print("Newly registered USER id: " + user.uid);

      return {
        "email": user.email,
        "provider_id": user.providerId,
        "id": user.uid,
        "is_email_verified": user.isEmailVerified,
        "is_new_user": result.additionalUserInfo.isNewUser,
        "created_at": user.metadata.creationTime,
        "last_signed_in_at": user.metadata.lastSignInTime
      };
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
