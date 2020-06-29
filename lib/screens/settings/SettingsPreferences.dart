import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/account_preferences.dart';
import 'package:instamfin/db/models/address.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class SettingsPreferences extends StatefulWidget {
  @override
  _SettingsPreferencesState createState() => _SettingsPreferencesState();
}

class _SettingsPreferencesState extends State<SettingsPreferences> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User _user = UserController().getCurrentUser();

  var transctionGroupValue = 0;
  List<bool> isSelectedView = [false, true];
  bool isTableView = false;

  TextEditingController _textEditingController = TextEditingController();

  Map<String, dynamic> userPreferencesJSON = new Map();
  Map<String, dynamic> accountPreferencesJSON = new Map();

  @override
  void initState() {
    super.initState();
    this.setAccountDetails();
    this.transctionGroupValue = _user.preferences.transactionGroupBy;
    if (_user.preferences.tableView) {
      isSelectedView = [true, false];
      isTableView = true;
    }

    this.userPreferencesJSON = _user.preferences.toJson();
  }

  Future setAccountDetails() async {
    try {
      Map<String, dynamic> data =
          (await _user.getFinanceDocReference().get()).data;

      this.accountPreferencesJSON = data['preferences'];
      AccountPreferences aPref =
          AccountPreferences.fromJson(accountPreferencesJSON);
      if (aPref.reportSignature != null && aPref.reportSignature != "")
        _textEditingController.text = aPref.reportSignature;
      else {
        Address add = Address.fromJson(data['address']);
        _textEditingController.text = add.toString();
      }
    } catch (err) {
      print("Unable to load Account Preferences!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Preferences"),
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
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: CustomColors.mfinLightGrey,
                elevation: 5.0,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Finance Preferences",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    RowHeaderText(textName: "REPORT's SIGNATURE"),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        controller: _textEditingController,
                        maxLines: 5,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: CustomColors.mfinLightGrey,
                elevation: 5.0,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "User Preferences",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      color: CustomColors.mfinButtonGreen,
                    ),
                    RowHeaderText(textName: "TRANSACTIONS GROUP BY"),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: transctionGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setTransaction(val);
                          },
                        ),
                        Text(
                          "Daily",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Georgia",
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: transctionGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setTransaction(val);
                          },
                        ),
                        Text(
                          "Weekly",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Georgia",
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: 2,
                          groupValue: transctionGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setTransaction(val);
                          },
                        ),
                        Text(
                          "Monthly",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Georgia",
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    RowHeaderText(textName: "COLLECTION VIEW"),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ToggleButtons(
                        borderColor: CustomColors.mfinButtonGreen,
                        selectedBorderColor: CustomColors.mfinBlue,
                        fillColor: CustomColors.mfinButtonGreen,
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: "Georgia",
                          color: CustomColors.mfinButtonGreen,
                          fontWeight: FontWeight.bold,
                        ),
                        borderWidth: 2,
                        selectedColor: CustomColors.mfinBlue,
                        borderRadius: BorderRadius.circular(5),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                right: 15, left: 15, bottom: 5, top: 5),
                            child: Text(
                              'Table View',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 15, left: 15, bottom: 5, top: 5),
                            child: Text(
                              'List View',
                            ),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isSelectedView.length; i++) {
                              isSelectedView[i] = i == index;
                            }
                          });
                        },
                        isSelected: isSelectedView,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setTransaction(int val) {
    setState(() {
      this.transctionGroupValue = val;
    });

    userPreferencesJSON['transaction_group_by'] = val;
  }

  _submit() async {
    if (_textEditingController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.errorSnackBar(
          "Report's signature should not be empty!", 2));
      return;
    } else {
      accountPreferencesJSON['report_signature'] = _textEditingController.text;
    }

    CustomDialogs.actionWaiting(context, "Updating Preferences!");
    if (isSelectedView[0]) {
      userPreferencesJSON['enable_table_view'] = true;
    } else {
      userPreferencesJSON['enable_table_view'] = false;
    }

    UserController _uc = UserController();
    var result = await _uc.updateTransactionSettings(
        userPreferencesJSON, accountPreferencesJSON);
    if (!result['is_success']) {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
          "Preferences updated successfully", 2));
      Navigator.pop(context);
    }
  }
}
