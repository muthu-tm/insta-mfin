import 'package:flutter/material.dart';
import 'package:instamfin/screens/customer/CustomersHome.dart';
import 'package:instamfin/screens/statistics/StatisticsHome.dart';
import 'package:instamfin/screens/transaction/TransactionHome.dart';
import 'package:instamfin/screens/settings/SettingsScreen.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

Widget bottomBar(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
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
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    "Customers",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
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
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
          child: Material(
            color: CustomColors.mfinBlue,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsHome(),
                    settings: RouteSettings(name: '/statistics'),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.assessment,
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    "Statistics",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
                ],
              ),
            ),
          ),
        ),
        SizedBox.fromSize(
          size: Size(screenWidth(context, dividedBy: 4), 100),
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
                    size: 35.0,
                    color: CustomColors.mfinButtonGreen,
                  ),
                  Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.mfinGrey,
                    ),
                  ), // text
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
