import 'package:flutter/material.dart';
import 'package:instamfin/Customer/profile.dart';
import 'package:instamfin/screens/utils/colors.dart';
import 'package:instamfin/screens/utils/validator.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

class LoginController extends StatefulWidget {
  const LoginController({this.toggleView});

  final Function toggleView;

  @override
  _LoginControllerState createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  String email;
  String password;
  bool _passwordVisible = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Login'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new Container(
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      child: FloatingActionButton(
                        onPressed: null,
                        backgroundColor: CustomColors.mfinWhite,
                        child: new Icon(
                          Icons.person,
                          size: 100,
                          color: CustomColors.mfinFadedButtonGreen,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10.0)),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            suffixIcon: Icon(
                              Icons.mail,
                              color: CustomColors.mfinFadedButtonGreen,
                              size: 35.0,
                            ),
                          ),
                          validator: (emailID) => FieldValidator.emailValidator(
                              emailID, setEmailID)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                          obscureText: hidePassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: CustomColors.mfinFadedButtonGreen,
                                size: 35.0,
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
                          validator: (passkey) =>
                              FieldValidator.passwordValidator(
                                  passkey, setPassKey)),
                    ),
                    Padding(padding: EdgeInsets.all(20.0)),
                    new InkWell(
                        onTap: _submit,
                        child: new Container(
                          width: 200.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                            color: CustomColors.mfinBlue,
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(
                            child: new Text(
                              'LOGIN',
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: CustomColors.mfinButtonGreen,
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
                          onPressed: () => widget.toggleView(),
                          child: new RichText(
                            text: new TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: new TextStyle(
                                fontSize: 22.0,
                                color: CustomColors.mfinAlertRed,
                              ),
                              children: <TextSpan>[
                                new TextSpan(text: "Don't have an account? "),
                                new TextSpan(
                                  text: ' SIGN UP',
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.mfinBlue,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    setState(() {
      this.email = emailID;
    });
  }

  setPassKey(String passkey) {
    setState(() {
      this.password = passkey;
    });
  }

  void _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      var result =
          await _authController.signInWithEmailPassword(email, password);

      if (!result['is_logged_in']) {
        print("Unable to Login: " + result['message']);
      } else {
        print("User logged in successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomerTransactionScreen()),
        );
      }
    } else {
      print('Form not valid');
    }
  }
}
