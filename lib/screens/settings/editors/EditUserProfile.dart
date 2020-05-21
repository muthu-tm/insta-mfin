import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/EditorBottomButtons.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

final UserService _userService = locator<UserService>();

class EditUserProfile extends StatefulWidget {
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final User user = _userService.cachedUser;
  final Map<String, dynamic> updatedUser = new Map();
  final Address updatedAddress = new Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();
  TextEditingController passwordController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  var _passwordVisible = false;
  var hidePassword = true;
  var groupValue = 0;

  @override
  Widget build(BuildContext context) {
    updatedUser['mobile_number'] = user.mobileNumber;

    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mfinGrey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Edit Profile'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: new Container(
              color: CustomColors.mfinLightGrey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RowHeaderText(textName: 'Name'),
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: user.name,
                      decoration: InputDecoration(
                        hintText: 'User Name',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your Name';
                        }
                        updatedUser['user_name'] = value;
                      },
                    ),
                  ),
                  RowHeaderText(textName: 'Password'),
                  ListTile(
                    title: new TextFormField(
                      keyboardType: TextInputType.text,
                      obscureText: hidePassword,
                      initialValue: user.password,
                      decoration: InputDecoration(
                        hintText: 'Enter your new Password',
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
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
                  RowHeaderText(textName: 'Email'),
                  ListTile(
                    title: new TextFormField(
                        keyboardType: TextInputType.text,
                        initialValue: user.emailID,
                        decoration: InputDecoration(
                          hintText: 'Enter your EmailID',
                          fillColor: CustomColors.mfinWhite,
                          filled: true,
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.mfinWhite)),
                        ),
                        validator: (email) {
                          if (email.trim().isEmpty) {
                            setEmailID("");
                            return null;
                          } else {
                            return FieldValidator.emailValidator(
                                email.trim(), setEmailID);
                          }
                        }),
                  ),
                  RowHeaderText(textName: 'Date Of Birth'),
                  ListTile(
                    title: new TextFormField(
                      decoration: InputDecoration(
                        hintText: DateUtils.formatDate(selectedDate),
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 3.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                        suffixIcon: Icon(
                          Icons.perm_contact_calendar,
                          color: CustomColors.mfinBlue,
                          size: 35.0,
                        ),
                      ),
                      enabled: false,
                      autofocus: false,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  RowHeaderText(textName: 'Gender'),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: groupValue,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text(
                            "Male",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                          Radio(
                            value: 1,
                            groupValue: groupValue,
                            activeColor: CustomColors.mfinBlue,
                            onChanged: (val) {
                              setSelectedRadio(val);
                            },
                          ),
                          Text(
                            "Female",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  AddressWidget("Address", user.address, updatedAddress),
                ],
              ),
            ),
          )),
      bottomSheet: EditorsActionButtons(() {
        _submit();
      }, () {
        Navigator.pop(context);
      }),
      // bottomNavigationBar: bottomBar(context),
    );
  }

  setPassKey(String passkey) {
    updatedUser['password'] = passkey;
  }

  setEmailID(String emailID) {
    updatedUser['emailID'] = emailID;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        updatedUser['date_of_birth'] = DateUtils.formatDate(picked);
      });
  }

  setSelectedRadio(int val) {
    this.groupValue = val;
    if (val == 0) {
      updatedUser['gender'] = Gender.Male.name;
    } else {
      updatedUser['gender'] = Gender.Female.name;
    }
  }

  Future<void> _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating Profile");
      updatedUser['address'] = updatedAddress.toJson();
      var result = await _userController.updateUser(updatedUser);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
        print("User profile update failed: " + result['message']);
      } else {
        Navigator.pop(context);
        print("Updated user profile data");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserSetting(),
            settings: RouteSettings(name: '/settings/user'),
          ),
        );
      }
    } else {
      print('Form not valid');
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill valid data!", 2));
    }
  }
}
