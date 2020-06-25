import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

class UserFinanceSetup extends StatelessWidget {
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    if (_user.primaryFinance != null && _user.primaryFinance != "") {
      return Home();
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: CustomColors.mfinLightGrey,
          body: Center(
            child: SingleChildScrollView(
              child: _getBody(context),
            ),
          ),
        ),
      );
    }
  }

  Widget _getBody(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Material(
                    elevation: 10.0,
                    child: Image.asset("images/icons/logo.png", height: 50),
                  ),
                ),
                PrimaryFinanceWidget("Finance Setup", false),
              ],
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: FlatButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  routeSettings: RouteSettings(name: "/home/help"),
                  builder: (context) {
                    return Center(
                      child: contactAndSupportDialog(),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info,
                color: CustomColors.mfinBlue,
              ),
              label: Text(
                ' Help & Support ',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.mfinBlue,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
