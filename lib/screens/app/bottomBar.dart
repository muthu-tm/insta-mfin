import 'package:flutter/material.dart';
import 'package:instamfin/screens/chit/ChitHome.dart';
import 'package:instamfin/screens/customer/CustomersHome.dart';
import 'package:instamfin/screens/reports/ReportsHome.dart';
import 'package:instamfin/screens/statistics/StatisticsHome.dart';
import 'package:instamfin/screens/transaction/TransactionHome.dart';
import 'package:instamfin/screens/settings/SettingsScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

import '../../app_localizations.dart';

Widget bottomBar(BuildContext context) {
  Size size = Size(screenWidth(context, dividedBy: 5), 100);
  bool chitEnabled = false;
  if (UserController().getCurrentUser().accPreferences.chitEnabled) {
    size = Size(screenWidth(context, dividedBy: 6), 100);
    chitEnabled = true;
  }

  return Container(
    height: 70,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox.fromSize(
          size: size,
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomersHome(),
                    settings: RouteSettings(name: '/customers'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.supervisor_account,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('customers'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 10,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: size,
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionScreen(),
                    settings: RouteSettings(name: '/transactions'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.content_copy,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('transactions'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 9,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
<<<<<<< HEAD
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 6), 100),
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChitHome(),
                    settings: RouteSettings(name: '/chit'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.transfer_within_a_station,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('chit_fund'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 10,
                      color: CustomColors.mfinGrey,
=======
        chitEnabled
            ? SizedBox.fromSize(
                size: size,
                child: Material(
                  color: CustomColors.mfinBlue,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChitHome(),
                          settings: RouteSettings(name: '/chit'),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.transfer_within_a_station,
                          size: 30.0,
                          color: CustomColors.mfinButtonGreen,
                        ),
                        Text(
                          "Chit Fund",
                          style: TextStyle(
                            fontFamily: "Georgia",
                            fontSize: 10,
                            color: CustomColors.mfinGrey,
                          ),
                        ),
                      ],
>>>>>>> 0c7b73a70bcca488bb640ec0d2051c2c54294b3f
                    ),
                  ),
                ),
              )
            : Container(),
        SizedBox.fromSize(
          size: size,
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportsHome(),
                    settings: RouteSettings(name: '/reports'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.description,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('reports'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 10,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: size,
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsHome(),
                    settings: RouteSettings(name: '/statistics'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.assessment,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('statistics'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 10,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: size,
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                    settings: RouteSettings(name: '/settings'),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    size: 30.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('settings'),
                    style: TextStyle(
                      fontFamily: "Georgia",
                      fontSize: 10,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

double screenWidth(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).width / dividedBy;
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double screenHeight(BuildContext context, {double dividedBy = 1}) {
  return screenSize(context).height / dividedBy;
}
