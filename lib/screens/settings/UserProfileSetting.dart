import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class UserProfileSetting extends StatefulWidget {
  const UserProfileSetting({this.toggleView});

  final Function toggleView;

  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();
  final User user = User(userState.mobileNumber);
  final UserController userController = UserController();
  TextEditingController passwordController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime dateOfBirth;

  var _passwordVisible = false;

  var hidePassword = true;

  String password = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('User Settings'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
          key: _formKey,
          child:SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(context).size.height * 0.90,
            color: CustomColors.mfinLightGrey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Name",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'User_Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter your UserName';
                      }
                    },
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Password",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter the Password',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: CustomColors.mfinBlue,
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
                        FieldValidator.passwordValidator(passkey, setPassKey),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Email",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter the Email',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    validator: (passkey) =>
                        FieldValidator.passwordValidator(passkey, setPassKey),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: new EdgeInsets.only(left: 15.0, top: 10),
                      child: new Text(
                        "Date Of Birth",
                        style: TextStyle(
                            color: CustomColors.mfinGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Enter the Password',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                      suffixIcon: Icon(
                        Icons.perm_contact_calendar,
                        color: CustomColors.mfinBlue,
                        size: 35.0,
                      ),
                    ),
                    validator: (passkey) =>
                        FieldValidator.passwordValidator(passkey, setPassKey),
                  ),
                ),
                  new Card(
                      color: CustomColors.mfinLightGrey,
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                            leading: new Text(
                              "Address",
                              style: TextStyle(
                                  color: CustomColors.mfinGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17),
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Street',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                              ),
                            ),
                          ),
                          ListTile(
                            title: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'City',
                                fillColor: CustomColors.mfinWhite,
                                filled: true,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                              ),
                            ),
                          ),
                          new Text(""),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
      padding: EdgeInsets.only(left: 15.0, right: 25.0, top: 25.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: CustomColors.mfinWhite,
                color: CustomColors.mfinButtonGreen,
                onPressed: () {
                  setState(() {
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: CustomColors.mfinWhite,
                color: CustomColors.mfinAlertRed,
                onPressed: () {
                  setState(() {

                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  setPassKey(String passkey) {
    setState(() {
      this.password = passkey;
    });
  }
}
