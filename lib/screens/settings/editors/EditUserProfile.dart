import 'package:flutter/material.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/AddressWidget.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/date_utils.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class EditUserProfile extends StatefulWidget {
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final User user = UserController().getCurrentUser();
  final Map<String, dynamic> updatedUser = new Map();
  final Address updatedAddress = new Address();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  DateTime selectedDate = DateTime.now();
  String gender;

  @override
  void initState() {
    super.initState();
    gender = user.gender;
    if (user.dateOfBirth != null)
      this._date.text = DateUtils.formatDate(
          DateTime.fromMillisecondsSinceEpoch(user.dateOfBirth));
    else
      this._date.text = DateUtils.formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    updatedUser['mobile_number'] = user.mobileNumber;

    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () {
          _submit();
        },
        label: Text(
          "Save",
          style: TextStyle(
            fontSize: 17,
            fontFamily: "Georgia",
            fontWeight: FontWeight.bold,
          ),
        ),
        splashColor: CustomColors.mfinWhite,
        icon: Icon(
          Icons.check,
          size: 35,
          color: CustomColors.mfinFadedButtonGreen,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                color: CustomColors.mfinLightGrey,
                child: Column(
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
                          return null;
                        },
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
                      title: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _date,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(
                                color: CustomColors.mfinBlue,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.mfinWhite)),
                              fillColor: CustomColors.mfinWhite,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.perm_contact_calendar,
                                size: 35,
                                color: CustomColors.mfinBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    RowHeaderText(textName: 'Gender'),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            title: Text(
                              "Male",
                              style: TextStyle(color: CustomColors.mfinBlue),
                            ),
                            value: "Male",
                            selected: gender.contains("Male"),
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val;
                                updatedUser['gender'] = "Male";
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            title: Text(
                              "Female",
                              style: TextStyle(color: CustomColors.mfinBlue),
                            ),
                            value: "Female",
                            selected: gender.contains("Female"),
                            groupValue: gender,
                            onChanged: (val) {
                              setState(() {
                                gender = val;
                                updatedUser['gender'] = "Female";
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AddressWidget("Address", user.address, updatedAddress),
              Padding(padding: EdgeInsets.only(top: 30, bottom: 30)),
            ],
          ),
        ),
      ),
    );
  }

  setEmailID(String emailID) {
    updatedUser['emailID'] = emailID;
  }

  TextEditingController _date = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        updatedUser['date_of_birth'] = DateUtils.getUTCDateEpoch(picked);
      });
  }

  Future<void> _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating YOU!");
      updatedUser['address'] = updatedAddress.toJson();
      var result = await _userController.updateUser(updatedUser);

      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 2));
      } else {
        Navigator.pop(context);
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
      _scaffoldKey.currentState.showSnackBar(
          CustomSnackBar.errorSnackBar("Please fill valid data!", 2));
    }
  }
}
