import 'package:flutter/material.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
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
                new Text(
                  "Please select your primary Finane",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 17.0,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Text(
                  "OR",
                  style: TextStyle(
                    color: CustomColors.mfinBlue,
                    fontSize: 17.0,
                    fontFamily: 'Georgia',
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
