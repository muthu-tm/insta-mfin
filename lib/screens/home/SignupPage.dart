import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/services/storage/image_uploader.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({this.toggleView});

  final Function toggleView;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthController _authController = AuthController();

  String password;
  String name;
  String mobileNumber;
  File _imageFile;
  bool isPicAdd = false;

  bool _passwordVisible = false;
  bool showPassword = false;
  bool requiredFieldsFilled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: CustomColors.mfinBlue,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: new Center(
        child: Container(
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      !isPicAdd
                          ? new Container(
                              height: 75.0,
                              width: 100.0,
                              padding: new EdgeInsets.only(top: 5.0),
                              child: FloatingActionButton(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                backgroundColor: CustomColors.mfinWhite,
                                child: new Icon(
                                  Icons.file_upload,
                                  size: 50,
                                ),
                                foregroundColor:
                                    CustomColors.mfinFadedButtonGreen,
                              ),
                            )
                          : Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image: Image.file(_imageFile).image),
                              ),
                            ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      new ListTile(
                          title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: Icon(
                                  Icons.sentiment_satisfied,
                                  color: CustomColors.mfinFadedButtonGreen,
                                  size: 35.0,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your Name';
                                }

                                setState(() => name = value.trim());
                                return null;
                              })),
                      new ListTile(
                          title: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Mobile Number',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: CustomColors.mfinFadedButtonGreen,
                                  size: 35.0,
                                ),
                              ),
                              validator: (mobileNumber) =>
                                  FieldValidator.mobileValidator(
                                      mobileNumber.trim(), setMobileNumber))),
                      new ListTile(
                          title: TextFormField(
                              obscureText: showPassword,
                              decoration: new InputDecoration(
                                hintText: "Password",
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: CustomColors.mfinFadedButtonGreen,
                                    size: 35.0,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (passkey) =>
                                  FieldValidator.passwordValidator(
                                      passkey, setPassKey))),
                      new ListTile(
                        title: TextFormField(
                          obscureText: true,
                          decoration: new InputDecoration(
                            hintText: "Confirm Password",
                            fillColor: CustomColors.mfinWhite,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Confirm your Password';
                            } else if (password != value) {
                              return 'Password should be matched';
                            }
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(15.0)),
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
                              'SIGN UP',
                              style: new TextStyle(
                                  fontSize: 22.0,
                                  color: CustomColors.mfinButtonGreen,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0)),
                      Row(
                        children: <Widget>[
                          new Container(
                            child: const Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: 20,
                                color: CustomColors.mfinWhite,
                              ),
                            ),
                          ),
                          FlatButton(
                            padding: const EdgeInsets.all(20.0),
                            onPressed: () => widget.toggleView(),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setMobileNumber(number) {
    setState(() {
      this.mobileNumber = number.trim();
    });
  }

  setPassKey(String passkey) {
    setState(() {
      this.password = passkey;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      isPicAdd = true;
    });
  }

  void _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Registering User");

      dynamic result = await _authController.registerWithMobileNumber(
          int.parse(mobileNumber), password, name, "");
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
        print("Unable to register USER: " + result['message']);
      } else {
        Navigator.pop(context);
        if (_imageFile != null) {
          _scaffoldKey.currentState.showSnackBar(
              CustomSnackBar.successSnackBar("$name added Successfully!", 1));
          CustomDialogs.actionWaiting(context, "Uploading Picture!");
          print("UPLOADING image file: " + _imageFile.toString());
          Uploader.uploadImage("user_profile_org", _imageFile.path,
              mobileNumber, int.parse(mobileNumber), () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomeScreen(),
                settings: RouteSettings(name: '/home'),
              ),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomeScreen(),
              settings: RouteSettings(name: '/home'),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    } else {
      print("Invalid form values");
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill required fields!", 2));
    }
  }
}
