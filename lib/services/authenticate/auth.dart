import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import './../../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(String user) {
    Map userMap = jsonDecode(user);
    return User.fromJson(userMap);
  }

  Future signInWithEmailPassword(String emailID, String passkey) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: emailID, password: passkey);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user.toString());
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future registerWithEmailPassword(String emailID, String passkey) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: emailID, password: passkey);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user.toString());
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
