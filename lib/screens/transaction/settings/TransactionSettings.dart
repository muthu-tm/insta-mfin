import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/db/models/user_preferences.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/screens/utils/CustomSnackBar.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class TransactionSetting extends StatefulWidget {
  @override
  _TransactionSettingState createState() => _TransactionSettingState();
}

class _TransactionSettingState extends State<TransactionSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserPreferences _preferences = UserController().getCurrentUser().preferences;

  var paymentGroupValue = 0;
  var transctionGroupValue = 0;
  String collectionNotificationAt = "08:00";
  String collectionCheckAt = "08:00";

  String _selectedCollNotification = "0";
  Map<String, String> _collNotificationMap = {
    "0": "00:00",
    "1": "03:00",
    "2": "06:00",
    "3": "09:00",
    "4": "12:00",
    "5": "15:00",
    "6": "18:00",
    "7": "21:00"
  };
  String _selectedCollCheck = "0";
  Map<String, String> _collCheckMap = {
    "0": "00:00",
    "1": "03:00",
    "2": "06:00",
    "3": "09:00",
    "4": "12:00",
    "5": "15:00",
    "6": "18:00",
    "7": "21:00"
  };

  Map<String, dynamic> preferencesJSON = new Map();

  @override
  void initState() {
    super.initState();
    this.paymentGroupValue = _preferences.paymentGroupBy;
    this.transctionGroupValue = _preferences.transactionGroupBy;
    this.collectionNotificationAt = _preferences.collectionNotificationAt;
    this.collectionCheckAt = _preferences.collectionCheckAt;

    this.preferencesJSON = _preferences.toJson();

    this._selectedCollNotification = _collNotificationMap.keys.firstWhere(
        (k) => _collNotificationMap[k] == _preferences.collectionNotificationAt,
        orElse: () => '0');
    this._selectedCollCheck = _collCheckMap.keys.firstWhere(
        (k) => _collCheckMap[k] == _preferences.collectionCheckAt,
        orElse: () => '0');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Transaction Preferences"),
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
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                color: CustomColors.mfinLightGrey,
                child: new Column(
                  children: <Widget>[
                    RowHeaderText(textName: "PAYMENTS GROUP BY:"),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: paymentGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setPayment(val);
                          },
                        ),
                        Text(
                          "Daily",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: 1,
                          groupValue: paymentGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setPayment(val);
                          },
                        ),
                        Text(
                          "Weekly",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 2,
                          groupValue: paymentGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setPayment(val);
                          },
                        ),
                        Text(
                          "Monthly",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: 3,
                          groupValue: paymentGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setPayment(val);
                          },
                        ),
                        Text(
                          "Yearly",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                            fontSize: 16,
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
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Radio(
                          value: 3,
                          groupValue: transctionGroupValue,
                          activeColor: CustomColors.mfinBlue,
                          onChanged: (val) {
                            setTransaction(val);
                          },
                        ),
                        Text(
                          "Yearly",
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.mfinBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 150,
                        child: Text(
                          "COLL CHECK AT:",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinLightGrey,
                        isExpanded: true,
                        items: _collCheckMap.entries.map(
                          (f) {
                            return DropdownMenuItem<String>(
                              value: f.key,
                              child: Text(f.value),
                            );
                          },
                        ).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedCollCheck = newVal;
                          });

                          preferencesJSON['collection_check_at'] =
                              _collNotificationMap[newVal];
                        },
                        value: _selectedCollCheck,
                      ),
                    ),
                    ListTile(
                      leading: SizedBox(
                        width: 150,
                        child: Text(
                          "NOTIFY ME AT:",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "Georgia",
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ),
                      title: DropdownButton<String>(
                        dropdownColor: CustomColors.mfinLightGrey,
                        isExpanded: true,
                        items: _collNotificationMap.entries.map(
                          (f) {
                            return DropdownMenuItem<String>(
                              value: f.key,
                              child: Text(f.value),
                            );
                          },
                        ).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _selectedCollNotification = newVal;
                          });
                          preferencesJSON['collection_notification_at'] =
                              _collNotificationMap[newVal];
                        },
                        value: _selectedCollNotification,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  setTransaction(int val) {
    setState(() {
      this.transctionGroupValue = val;
    });

    preferencesJSON['transaction_group_by'] = val;
  }

  setPayment(int val) {
    setState(() {
      this.paymentGroupValue = val;
    });

    preferencesJSON['payment_group_by'] = val;
  }

  _submit() async {
    CustomDialogs.actionWaiting(context, "Updating Preferences!");
    UserController _uc = UserController();

    var result = await _uc.updateTransactionSettings(preferencesJSON);
    if (!result['is_success']) {
      Navigator.pop(context);
      _scaffoldKey.currentState
          .showSnackBar(CustomSnackBar.errorSnackBar(result['message'], 5));
      print("Unable to Update Transaction Preferences: " + result['message']);
    } else {
      _scaffoldKey.currentState.showSnackBar(CustomSnackBar.successSnackBar(
          "Preferences updated successfully", 2));
      print("Preferences updated successfully");
      Navigator.pop(context);
    }
  }
}
