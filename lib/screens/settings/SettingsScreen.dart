import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/settings/AppSettings.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: openDrawer(context),
      appBar: topAppBar(context),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinanceSetting(),
                        settings: RouteSettings(name: '/settings/finance'),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.account_balance,
                        size: 50.0,
                        color: CustomColors.mfinBlue,
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Finance Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSetting(),
                        settings: RouteSettings(name: '/settings/user'),
                      ),
                    );
                  }, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.account_box,
                        size: 50.0,
                        color: CustomColors.mfinBlue,
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Profile Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen,
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.notifications_active,
                        size: 50.0,
                        color: CustomColors.mfinBlue,
                      ),
                      Padding(padding: EdgeInsets.all(5.0)),
                      Text(
                        "Notifications Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppSettings(),
                        settings: RouteSettings(name: '/settings/app'),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.phonelink_setup,
                        size: 50.0,
                        color: CustomColors.mfinBlue,
                      ),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "App Settings",
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.mfinGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // text
                    ],
                  ),
                ),
              ],
            ),
            AddFinanceWidget(),
          ],
        ),
      ),
      bottomSheet: bottomBar(context),
    );
  }
}
