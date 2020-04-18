import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/AddAdminPage.dart';
import 'package:instamfin/screens/settings/BranchSetting.dart';
import 'package:instamfin/screens/settings/CompanyProfileSettings.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/utils/users_utils.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';

Widget openDrawer(BuildContext context) {
  final AuthController _authController = AuthController();

  return new Drawer(
      child: new ListView(children: <Widget>[
    new UserAccountsDrawerHeader(
        accountName: Text(userState.name),
        accountEmail: Text("A&E Specialties"),
        arrowColor: CustomColors.mfinBlue,
        onDetailsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProfileSetting()),
          );
        },
        currentAccountPicture: new CircleAvatar(
          backgroundImage: UserUtils.getUserDisplayImage(),
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
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('View all Customers'),
          trailing: new Icon(Icons.keyboard_arrow_right),
          onTap: () => null,
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
            MaterialPageRoute(builder: (context) => CompanyProfileSetting()),
          );
        }),
            new ListTile(
        leading: new Icon(Icons.store,
            color: CustomColors.mfinButtonGreen),
        title: new Text('Branch Settings'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BranchSetting()),
          );
        }),            new ListTile(
        leading: new Icon(Icons.supervised_user_circle,
            color: CustomColors.mfinButtonGreen),
        title: new Text('User Settings'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserSetting()),
          );
        }),
    new ListTile(
      leading: new Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
      title: new Text('Profile Settings'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileSetting()),
        );
      },
    ),
        new ListTile(
      leading: new Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
      title: new Text('User Management'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddAdminPage()),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Authenticate()),
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
