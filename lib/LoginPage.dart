import 'package:flutter/material.dart';
import 'package:instamfin/SignupPage.dart';
import 'package:instamfin/customPasswordField.dart';

import 'TextFormField.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key key}) : super(key: key);

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String password = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(20.0)),
          new Container(
            height: 100.0,
            width: 100.0,
            child: FloatingActionButton(
              onPressed: null,
              backgroundColor: Colors.white,
              child: new Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),
              foregroundColor: Colors.grey,
            ),
          ),
          Padding(padding: EdgeInsets.all(10.0)),
          Container(
            padding: EdgeInsets.all(10),
            child: CutomTextField('Email',Colors.white,Icons.mail,TextInputType.emailAddress),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              obscureText: hidePassword,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                fillColor: Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue[200], size: 35.0,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              validator: (value) =>
                  value.isEmpty ? 'Password is required' : null,
            ),
          ),
          Padding(padding: EdgeInsets.all(30.0)),
          new InkWell(
              onTap: _submit,
              child: new Container(
                width: 200.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(10.0),
                ),
                child: new Center(
                  child: new Text(
                    'LOGIN',
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
          Padding(padding: EdgeInsets.all(25.0)),
          Container(
              child: Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  RegisterForm();
                },
                textColor: Colors.blue,
                child: new RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 22.0,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: "Don't have an account?  "),
                      new TextSpan(
                        text: ' SIGN UP',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ))
        ],
      ),
    );
  }

  void _submit() {
    _formKey.currentState.validate();
    print('Form submitted');
  }
}
