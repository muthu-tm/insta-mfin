import 'package:flutter/material.dart';
import 'package:instamfin/db/enums/gender.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';


final UserService _userService = locator<UserService>();

class UserProfileSetting extends StatefulWidget {

  @override
  _UserProfileSettingState createState() => _UserProfileSettingState();
}

class _UserProfileSettingState extends State<UserProfileSetting> {
  final User user = _userService.cachedUser;
  final Map<String, dynamic> updatedUser = new Map();
  final Address updatedAddress = new Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode myFocusNode = FocusNode();
  final UserController _userController = UserController();
  TextEditingController passwordController = TextEditingController();


  DateTime selectedDate = DateTime.now();
  var _passwordVisible = false;
  var hidePassword = true;
  var groupValue = -1;

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
              height: MediaQuery.of(context).size.height * 1.16,
              color: CustomColors.mfinLightGrey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RowHeaderTextBox(textName: 'Name'),
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
                  RowHeaderTextBox(textName: 'Password'),
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
                  RowHeaderTextBox(textName: 'Email'),
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
                      validator: (passkey) =>
                          FieldValidator.emailValidator(passkey, setEmailID),
                    ),
                  ),
                  RowHeaderTextBox(textName: 'Date Of Birth'),
                  ListTile(
                    title: new TextFormField(
                      // controller: _date,
                      initialValue: user.dateOfBirth,
                      decoration: InputDecoration(
                        hintText: DateUtils.getCurrentFormattedDate(),
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
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  RowHeaderTextBox(textName: 'Gender'),
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
                  AddressWidget(
                      "Address", user.address, updatedAddress),
                  // new Card(
                  //   color: CustomColors.mfinLightGrey,
                  //   child: new Column(
                  //     children: <Widget>[
                  //       ListTile(
                  //         leading: new Text(
                  //           "Address",
                  //           style: TextStyle(
                  //               color: CustomColors.mfinGrey,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 17),
                  //         ),
                  //       ),
                  //       ListTile(
                  //         title: TextFormField(
                  //           initialValue: widget.user.address.street,
                  //           keyboardType: TextInputType.text,
                  //           decoration: InputDecoration(
                  //             hintText: 'Building No. & Street',
                  //             fillColor: CustomColors.mfinWhite,
                  //             filled: true,
                  //             contentPadding: new EdgeInsets.symmetric(
                  //                 vertical: 5.0, horizontal: 5.0),
                  //           ),
                  //           validator: (street) {
                  //             if (street.trim() != "") {
                  //                 widget.user.address.street = street.trim();
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       ListTile(
                  //         title: TextFormField(
                  //           keyboardType: TextInputType.text,
                  //           initialValue: widget.user.address.city,
                  //           decoration: InputDecoration(
                  //             hintText: 'City',
                  //             fillColor: CustomColors.mfinWhite,
                  //             filled: true,
                  //             contentPadding: new EdgeInsets.symmetric(
                  //                 vertical: 5.0, horizontal: 5.0),
                  //           ),
                  //           validator: (city) {
                  //             if (city.trim() != "") {
                  //                 widget.user.address.city = city.trim();
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       ListTile(
                  //         title: TextFormField(
                  //           keyboardType: TextInputType.text,
                  //           initialValue: widget.user.address.state,
                  //           decoration: InputDecoration(
                  //             hintText: 'State',
                  //             fillColor: CustomColors.mfinWhite,
                  //             filled: true,
                  //             contentPadding: new EdgeInsets.symmetric(
                  //                 vertical: 5.0, horizontal: 5.0),
                  //           ),
                  //           validator: (state) {
                  //             if (state.trim() != "") {
                  //                 widget.user.address.state = state.trim();
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //       ListTile(
                  //         title: TextFormField(
                  //           keyboardType: TextInputType.text,
                  //           initialValue: widget.user.address.pincode,
                  //           decoration: InputDecoration(
                  //             hintText: 'Pincode',
                  //             fillColor: CustomColors.mfinWhite,
                  //             filled: true,
                  //             contentPadding: new EdgeInsets.symmetric(
                  //                 vertical: 5.0, horizontal: 5.0),
                  //           ),
                  //           validator: (pinCode) {
                  //             if (pinCode.trim() != "") {
                  //                 widget.user.address.pincode = pinCode.trim();
                  //             }
                  //             return null;
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          )),
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
                  textColor: CustomColors.mfinButtonGreen,
                  color: CustomColors.mfinBlue,
                  onPressed: () => _submit(),
                )),
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(
                    child: new RaisedButton(
                  child: new Text("Close"),
                  textColor: CustomColors.mfinAlertRed,
                  color: CustomColors.mfinBlue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
    updatedUser['password'] = passkey;
  }

  setEmailID(String emailID) {
    updatedUser['emailID'] = emailID;
  }

  TextEditingController _date = new TextEditingController();

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
        _date.value = TextEditingValue(text: DateUtils.formatDate(picked));
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
          MaterialPageRoute(builder: (context) => UserSetting()),
        );
      }
    } else {
      print('Form not valid');
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill valid data!", 2));
    }
  }
}

class RowHeaderTextBox extends StatelessWidget {
  RowHeaderTextBox({this.textName});

  final String textName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(left: 15.0, top: 10),
          child: new Text(
            textName,
            style: TextStyle(
                color: CustomColors.mfinGrey,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
      ],
    );
  }
}
