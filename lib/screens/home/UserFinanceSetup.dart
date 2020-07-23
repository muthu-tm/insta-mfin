import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/home/HomeScreen.dart';
import 'package:instamfin/screens/settings/widgets/PrimaryFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';
import 'package:instamfin/app_localizations.dart';

class UserFinanceSetup extends StatelessWidget {
  final User _user = UserController().getCurrentUser();

  @override
  Widget build(BuildContext context) {
    if (_user.primary.financeID != null && _user.primary.financeID != "") {
      return WillPopScope(
        onWillPop: () => CustomDialogs.confirm(
            context, AppLocalizations.of(context).translate('warning'), AppLocalizations.of(context).translate('exit_confirmation'), () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AuthPage(),
              settings: RouteSettings(name: '/close'),
            ),
            (Route<dynamic> route) => false,
          );
        }, () => Navigator.pop(context, false)),
        child: HomeScreen(),
      );
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "images/icons/logo.png",
                      height: 50,
                      width: 50,
                    ),
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
                      child: contactAndSupportDialog(context),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info,
                color: CustomColors.mfinBlue,
              ),
              label: Text(
                AppLocalizations.of(context).translate('help_support'),
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
