import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/transaction/widgets/PaymentTemplateWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/RowHeaderText.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class TransactionSetting extends StatefulWidget {
  @override
  _TransactionSettingState createState() => _TransactionSettingState();
}

class _TransactionSettingState extends State<TransactionSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final UserService _userService = locator<UserService>();

  var paymentGroupValue = 0;

  var transctionGroupValue = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Transaction Settings"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: new SingleChildScrollView(
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PaymentTemplateWidget(_scaffoldKey),
              Card(
                color: CustomColors.mfinLightGrey,
                child: new Column(
                  children: <Widget>[
                    RowHeaderText(textName: "Payments group by"),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
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
                              "Date",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
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
                              "Month",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                            Radio(
                              value: 2,
                              groupValue: paymentGroupValue,
                              activeColor: CustomColors.mfinBlue,
                              onChanged: (val) {
                                setPayment(val);
                              },
                            ),
                            Text(
                              "Year",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    RowHeaderText(textName: "Transactions group by"),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
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
                              "Date",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
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
                              "Month",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
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
                              "Year",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      child: new RaisedButton(
                        splashColor: CustomColors.mfinButtonGreen,
                        child: new Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textColor: CustomColors.mfinButtonGreen,
                        color: CustomColors.mfinBlue,
                        onPressed: () {
                          // onPressedSave();
                        },
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
  }

  setPayment(int val) {
    setState(() {
      this.paymentGroupValue = val;
    });
  }
}
