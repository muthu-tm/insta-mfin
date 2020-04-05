import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/settings/CompanyProfileSettings.dart';
import 'package:instamfin/screens/utils/colors.dart';

Widget openDrawer(BuildContext context) {
  return new Drawer(
      child: new ListView(children: <Widget>[
    new UserAccountsDrawerHeader(
      accountName: const Text("Vale"),
      accountEmail: const Text("A&E Specialties"),
      currentAccountPicture: new CircleAvatar(
          backgroundColor: CustomColors.mfinBlue, child: new Text("Test")),
    ),
    new ListTile(
      leading: new Icon(Icons.home),
      title: new Text('Home'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserHomeScreen()),
      ),
    ),
    new Divider(),
    new ExpansionTile(
      title: new Text("Transactions"),
      leading: new Icon(Icons.content_copy),
      trailing: new Icon(Icons.keyboard_arrow_down),
      children: <Widget>[
        new ListTile(
          title: new Text('Make a Transaction'),
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('Edit a Transaction'),
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('View Transactions'),
          onTap: () => null,
        ),
      ],
    ),
    new ListTile(
      leading: new Icon(Icons.supervisor_account),
      title: new Text('My Customer'),
      onTap: () => null,
    ),
    new ExpansionTile(
      title: new Text("Statistics"),
      leading: new Icon(Icons.assessment),
      trailing: new Icon(Icons.keyboard_arrow_down),
      children: <Widget>[
        new ListTile(
          title: new Text('View Daily Statistics'),
          onTap: () => null,
        ),
        new ListTile(
          title: new Text('View Monthly Statistics'),
          onTap: () => null,
        )
      ],
    ),
    new Divider(),
    new ListTile(
      leading: new Icon(Icons.account_balance),
      title: new Text('Company Settings'),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompanyProfileSetting()),
      ),
    ),
        new Divider(),
    new ListTile(
      leading: new Icon(Icons.notifications),
      title: new Text('Notifications'),
      onTap: () => null,
    ),
        new Divider(),
    new ListTile(
      leading: new Icon(Icons.settings),
      title: new Text('Profile Settings'),
      onTap: () => null,
    ),
    new Divider(),
    new ListTile(
      leading: new Icon(Icons.headset_mic),
      title: new Text('Help & Support'),
      onTap: () => null,
    ),
    new ListTile(
      leading: new Icon(Icons.error),
      title: new Text('Logout'),
      onTap: () => null,
    ),
    new Container(
        color: CustomColors.mfinBlue,
        child: new ListTile(
          leading: new Text(
            'INSTA - MFIN',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: Text(
            "v0.50",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () => null,
        )),
  ]));
}
