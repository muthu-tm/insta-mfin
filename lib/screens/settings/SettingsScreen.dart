import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/AppSettings.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (Route<dynamic> route) => false,
      ),
      child: Scaffold(
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
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 110,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FinanceSetting(),
                              settings:
                                  RouteSettings(name: '/settings/finance'),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.account_balance,
                              size: 45.0,
                              color: CustomColors.mfinButtonGreen,
                            ),
                            Padding(padding: EdgeInsets.all(05.0)),
                            Text(
                              "Finance Settings",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 110,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSetting(),
                              settings: RouteSettings(name: '/settings/user'),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.account_box,
                              size: 45.0,
                              color: CustomColors.mfinButtonGreen,
                            ),
                            Padding(padding: EdgeInsets.all(05.0)),
                            Text(
                              "Profile Settings",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 110,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.notifications_active,
                              size: 45.0,
                              color: CustomColors.mfinButtonGreen,
                            ),
                            Padding(padding: EdgeInsets.all(5.0)),
                            Text(
                              "Notification Settings",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.30,
                      height: 110,
                      child: InkWell(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.phonelink_setup,
                              size: 45.0,
                              color: CustomColors.mfinButtonGreen,
                            ),
                            Padding(padding: EdgeInsets.all(05.0)),
                            Text(
                              "App Settings",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Georgia',
                                color: CustomColors.mfinBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AddFinanceWidget(),
            ],
          ),
        ),
        bottomSheet: bottomBar(context),
      ),
    );
  }
}
