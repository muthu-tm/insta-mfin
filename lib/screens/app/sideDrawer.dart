import 'package:flutter/material.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/customer/ViewCustomer.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';

UserService _userService = locator<UserService>();

Widget openDrawer(BuildContext context) {
  final AuthController _authController = AuthController();

  return new Drawer(
      child: new ListView(children: <Widget>[
    new UserAccountsDrawerHeader(
        accountName: Text(_userService.cachedUser.name),
        accountEmail: Text(_userService.cachedUser.emailID),
        arrowColor: CustomColors.mfinBlue,
        onDetailsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserSetting()),
          );
        },
        currentAccountPicture: new CircleAvatar(
          backgroundImage: _userService.getUserDisplayImage(),
          backgroundColor: CustomColors.mfinBlue,
        )),
    new ListTile(
      leading: new Icon(Icons.home, color: CustomColors.mfinButtonGreen),
      title: new Text('Home'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomeScreen()),
      ),
    ),
    new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
    new ExpansionTile(
      title: new Text("Transactions"),
      leading:
          new Icon(Icons.content_copy, color: CustomColors.mfinButtonGreen),
      children: <Widget>[
        new ListTile(
          title: new Text('Make a Transaction'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('View Transactions'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => null,
        ),
      ],
    ),
    new ExpansionTile(
      leading: new Icon(Icons.supervisor_account,
          color: CustomColors.mfinButtonGreen),
      title: new Text('My Customers'),
      children: <Widget>[
        new ListTile(
          title: new Text('Add a Customer'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AddCustomer()),
            (Route<dynamic> route) => false,
          ),
        ),
        new ListTile(
          title: new Text('View Customers'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ViewCustomer()),
            (Route<dynamic> route) => false,
          ),
        ),
      ],
    ),
    new ExpansionTile(
      title: new Text("Statistics"),
      leading: new Icon(Icons.assessment, color: CustomColors.mfinButtonGreen),
      children: <Widget>[
        new ListTile(
          title: new Text('Daily Statistics'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('Monthly Statistics'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => null,
        )
      ],
    ),
    new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
    new ListTile(
      leading: new Icon(Icons.notifications_active,
          color: CustomColors.mfinButtonGreen),
      title: new Text('Notifications'),
      onTap: () => null,
    ),
    new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
    new ListTile(
        leading: new Icon(Icons.account_balance,
            color: CustomColors.mfinButtonGreen),
        title: new Text('Company Settings'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FinanceSetting()),
          );
        }),
    new ListTile(
      leading: new Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
      title: new Text('Profile Settings'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserSetting()),
        );
      },
    ),
    new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
    new ListTile(
      leading: new Icon(Icons.headset_mic, color: CustomColors.mfinButtonGreen),
      title: new Text('Help & Support'),
      onTap: () => null,
    ),
    new ListTile(
      leading: new Icon(Icons.error, color: CustomColors.mfinAlertRed),
      title: new Text('Logout'),
      onTap: () => CustomDialogs.confirm(
          context, "Warning!", "Do you really want to exit?", () async {
        await _authController.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Authenticate()),
          (Route<dynamic> route) => false,
        );
      }, () => Navigator.pop(context, false)),
    ),
    new Container(
        color: CustomColors.mfinBlue,
        child: new ListTile(
          leading: new Text(
            'InstamFIN',
            style: TextStyle(
              color: CustomColors.mfinButtonGreen,
              fontSize: 15.0,
            ),
          ),
          trailing: Text(
            "v0.5.0 (beta)",
            style: TextStyle(
              color: CustomColors.mfinButtonGreen,
              fontSize: 15.0,
            ),
          ),
          onTap: () => null,
        )),
  ]));
}
