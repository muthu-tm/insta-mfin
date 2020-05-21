import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/appBar.dart';
import 'package:instamfin/screens/app/bottomBar.dart';
import 'package:instamfin/screens/app/sideDrawer.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/AddFinanceWidget.dart';
import 'package:instamfin/screens/utils/IconButton.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

class SettingsScreen extends StatelessWidget {
  final UserService _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    User user = _userService.cachedUser;

    return new Scaffold(
      drawer: openDrawer(context),
      appBar: topAppBar(context),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {
                    // _financeSetting(user, context), // button pressed
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
                      customIconButton(Icons.account_balance, 50.0,
                          CustomColors.mfinBlue, () {}),
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
                  splashColor: CustomColors.mfinButtonGreen, // splash color
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
                      customIconButton(
                          Icons.account_box, 50.0, CustomColors.mfinBlue, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserSetting(),
                            settings: RouteSettings(name: '/settings/user'),
                          ),
                        );
                      }),
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
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, //change here don't //worked
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                InkWell(
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(Icons.notifications_active, 50.0,
                          CustomColors.mfinBlue, () {
                        print("Pressed Notifications");
                      }),
                      Padding(padding: EdgeInsets.all(05.0)),
                      Text(
                        "Notifications Settings",
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
                  splashColor: CustomColors.mfinButtonGreen, // splash color
                  onTap: () {}, // button pressed
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      customIconButton(
                          Icons.phonelink_setup, 50.0, CustomColors.mfinBlue,
                          () {
                        print("Pressed App Settings");
                      }),
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

  // _financeSetting(User user, context) {
  //   if (user.primaryFinance != null || user.primaryFinance != "") {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => FinanceSetting()),
  //     );
  //   } else {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => EditPrimaryFinance()),
  //     );
  //   }
  // }
}
