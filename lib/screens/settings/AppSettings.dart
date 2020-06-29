import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserPreferences _preferences = UserController().getCurrentUser().preferences;

  var transctionGroupValue = 0;
  bool isTableView = false;

  Map<String, dynamic> preferencesJSON = new Map();

  @override
  void initState() {
    super.initState();
    this.transctionGroupValue = _preferences.transactionGroupBy;
    this.isTableView =
        (_preferences.tableView != null) ? _preferences.tableView : false;

    this.preferencesJSON = _preferences.toJson();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("App Settings"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
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
            Card(
              color: CustomColors.mfinLightGrey,
              child: new Column(
                children: <Widget>[
                  RowHeaderText(textName: "TRANSACTIONS GROUP BY:"),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 10.0,
                shadowColor: CustomColors.mfinButtonGreen,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 50,
                  child: CheckboxListTile(
                    value: isTableView,
                    onChanged: (bool newValue) {
                      setState(() {
                        isTableView = newValue;
                      });
                      preferencesJSON['enable_table_view'] = newValue;
                    },
                    title: Text(
                      "Enable | Table | View ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Georgia",
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mfinBlue,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: CustomColors.mfinBlue,
                  ),
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

    preferencesJSON['transaction_group_by'] = val;
  }

  _submit() async {
    CustomDialogs.actionWaiting(context, "Updating Preferences!");
    UserController _uc = UserController();

    var result = await _uc.updateTransactionSettings(preferencesJSON, {});
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
