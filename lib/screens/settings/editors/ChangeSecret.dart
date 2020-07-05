import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/screens/utils/field_validator.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class ChangeSecret extends StatefulWidget {
  @override
  _ChangeSecretState createState() => _ChangeSecretState();
}

class _ChangeSecretState extends State<ChangeSecret> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String secretKey = "";
  String confirmKey = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Change Secret KEY"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomColors.mfinBlue,
        onPressed: () async {
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
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 10),
            child: Card(
              color: CustomColors.mfinAlertRed.withOpacity(0.4),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  RowHeaderText(textName: "New Secret KEY"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      autofocus: false,
                      validator: (value) {
                        return FieldValidator.passwordValidator(
                            value, setSecretKey);
                      },
                    ),
                  ),
                  RowHeaderText(textName: "Confirm Secret KEY"),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: CustomColors.mfinBlue,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: CustomColors.mfinWhite,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: CustomColors.mfinWhite)),
                      ),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Re-Enter your New KEY';
                        } else {
                          if (secretKey != value) {
                            return "Error! Secret KEY mismatch!";
                          }
                          confirmKey = value;
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  setSecretKey(String sKey) {
    secretKey = sKey;
  }

  _submit() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      CustomDialogs.actionWaiting(context, "Updating KEY!");

      UserController _uc = UserController();
      var result = await _uc.updateSecretKey(secretKey);
      if (!result['is_success']) {
        Navigator.pop(context);
        _scaffoldKey.currentState
            .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      } else {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
            "Your Secret KEY updated successfully", 2));
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);
      }
    }
  }
}
