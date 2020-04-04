import 'package:flutter/material.dart';
import './SignupPage.dart';
import './LoginPage.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginController(toggleView: toggleView);
    } else {
      return RegisterForm(toggleView:  toggleView);
    }
  }
}