import 'package:flutter/material.dart';
import 'package:instamfin/screens/settings/AddNewFinance.dart';
import 'package:instamfin/screens/settings/PrimaryFinanceSetting.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class PrimaryFinanceWidget extends StatelessWidget {
  final UserController _userController = UserController();

  PrimaryFinanceWidget(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _userController.getPrimaryFinanceDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            if (snapshot.data['finance_name'] != null) {
              children = <Widget>[
                ListTile(
                  leading: Icon(Icons.account_balance,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['finance_name'],
                    decoration: InputDecoration(
                      hintText: 'Company_Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.view_stream,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['branch_name'],
                    decoration: InputDecoration(
                      hintText: 'Branch_Name',
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.view_headline,
                      color: CustomColors.mfinBlue, size: 30.0),
                  title: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: snapshot.data['sub_branch_name'],
                    decoration: InputDecoration(
                      hintText: 'Sub_Branch',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 3.0),
                      fillColor: CustomColors.mfinWhite,
                      filled: true,
                      enabled: false,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: CustomColors.mfinGrey)),
                    ),
                    enabled: false,
                    autofocus: false,
                  ),
                ),
              ];
            } else {
              children = <Widget>[
                new Row(children: <Widget>[
                  Text(
                    "Already a registered Financier? Great!",
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 17,
                      color: CustomColors.mfinBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                Padding(
                    padding: EdgeInsets.only(left: 115.0, top: 10),
                    child: InkWell(
                      splashColor: CustomColors.mfinButtonGreen,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrimaryFinanceSetting()),
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            color: CustomColors.mfinBlue,
                            child: new Row(children: <Widget>[
                              customIconButton(Icons.edit, 35.0,
                                  CustomColors.mfinButtonGreen, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddFinancePage()),
                                );
                              }),
                              new Text(
                                "Select your primary Finance!",
                                style: TextStyle(
                                    fontFamily: 'Georgia',
                                    color: CustomColors.mfinButtonGreen,
                                    fontSize: 17.0),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: new Text(
                      "OR",
                      style: TextStyle(
                        color: CustomColors.mfinGrey,
                        fontSize: 17.0,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                AddFinanceWidget(),
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: CustomColors.mfinAlertRed,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Unable to load, Error!'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }

          return new Card(
            color: CustomColors.mfinLightGrey,
            child: new Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.work,
                      size: 30,
                      color: CustomColors.mfinFadedButtonGreen,
                    ),
                    title: new Text(
                      title,
                      style: TextStyle(color: CustomColors.mfinBlue),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: CustomColors.mfinBlue,
                      ),
                      onPressed: () {},
                    )),
                new Divider(
                  color: CustomColors.mfinBlue,
                  thickness: 1,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
