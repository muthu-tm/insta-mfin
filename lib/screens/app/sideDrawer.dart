import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/CompanyProfileSettings.dart';
import 'package:instamfin/screens/settings/UserProfileSetting.dart';
import 'package:instamfin/screens/utils/colors.dart';

Widget openDrawer(BuildContext context) {
  return new Drawer(
      child: new ListView(children: <Widget>[
    new UserAccountsDrawerHeader(
      accountName: const Text("Vale"),
      accountEmail: const Text("A&E Specialties"),
      arrowColor: CustomColors.mfinBlue,
      onDetailsPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileSetting()),
        );
      },
      currentAccountPicture: new CircleAvatar(
          backgroundColor: CustomColors.mfinBlue, child: new Text("Test")),
    ),
    new ListTile(
      leading: new Icon(Icons.home, color: CustomColors.mfinButtonGreen),
      title: new Text('Home'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomeScreen()),
      ),
    ),
    new Divider(),
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
    new Divider(),
    new ListTile(
      leading: new Icon(Icons.notifications_active,
          color: CustomColors.mfinButtonGreen),
      title: new Text('Notifications'),
      onTap: () => null,
    ),
    new Divider(),
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
      leading: new Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
      title: new Text('Profile Settings'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileSetting()),
        );
      },
    ),
    new Divider(),
    new ListTile(
      leading: new Icon(Icons.headset_mic, color: CustomColors.mfinButtonGreen),
      title: new Text('Help & Support'),
      onTap: () => null,
    ),
    new ListTile(
      leading: new Icon(Icons.error, color: CustomColors.mfinAlertRed),
      title: new Text('Logout'),
      onTap: () => null,
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
