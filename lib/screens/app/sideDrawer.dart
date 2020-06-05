import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/app/NotificationHome.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/customer/CustomersFilteredView.dart';
import 'package:instamfin/screens/home/Home.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

Widget openDrawer(BuildContext context) {
  final User _user = UserController().getCurrentUser();
  final AuthController _authController = AuthController();

  return new Drawer(
    child: new ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: CustomColors.mfinBlue,
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                child: _user.getProfilePicPath() == ""
                    ? Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: CustomColors.mfinFadedButtonGreen,
                              style: BorderStyle.solid,
                              width: 2.0),
                          // image:
                        ),
                        child: Icon(
                          Icons.person,
                          size: 45.0,
                          color: CustomColors.mfinLightGrey,
                        ),
                      )
                    : CircleAvatar(
                        radius: 45.0,
                        backgroundImage:
                            NetworkImage(_user.getProfilePicPath()),
                        backgroundColor: Colors.transparent,
                      ),
              ),
              Text(
                _user.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.mfinLightGrey,
                ),
              ),
              Text(
                _user.mobileNumber.toString(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.mfinLightGrey,
                ),
              ),
            ],
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.home, color: CustomColors.mfinButtonGreen),
          title: new Text('Home'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomeScreen(),
              settings: RouteSettings(name: '/home'),
            ),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomer(),
                  settings: RouteSettings(name: '/customers/add'),
                ),
              ),
            ),
            new ListTile(
              title: new Text('View Customers'),
              trailing: new Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomersFilteredView(),
                  settings: RouteSettings(name: '/customers'),
                ),
                (Route<dynamic> route) => false,
              ),
            ),
          ],
        ),
        new ExpansionTile(
          title: new Text("Statistics"),
          leading:
              new Icon(Icons.assessment, color: CustomColors.mfinButtonGreen),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationHome(),
                settings: RouteSettings(name: '/notifications'),
              ),
            );
          },
        ),
        new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        new ListTile(
          leading: new Icon(Icons.account_balance,
              color: CustomColors.mfinButtonGreen),
          title: new Text('Finance Settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinanceSetting(),
                settings: RouteSettings(name: '/settings/finance'),
              ),
            );
          },
        ),
        new ListTile(
          leading:
              new Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
          title: new Text('Profile Settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSetting(),
                settings: RouteSettings(name: '/settings/user'),
              ),
            );
          },
        ),
        new Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        new ListTile(
          leading:
              new Icon(Icons.headset_mic, color: CustomColors.mfinButtonGreen),
          title: new Text('Help & Support'),
          onTap: () {
            showDialog(
              context: context,
              routeSettings: RouteSettings(name: "/home/help"),
              builder: (context) {
                return Center(
                  child: contactAndSupportDialog(),
                );
              },
            );
          },
        ),
        new ListTile(
          leading: new Icon(Icons.error, color: CustomColors.mfinAlertRed),
          title: new Text('Logout'),
          onTap: () => CustomDialogs.confirm(
              context, "Warning!", "Do you really want to exit?", () async {
            await _authController.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AuthPage(),
                settings: RouteSettings(name: '/logout'),
              ),
              (Route<dynamic> route) => false,
            );
          }, () => Navigator.pop(context, false)),
        ),
        Container(
          color: CustomColors.mfinBlue,
          child: AboutListTile(
            dense: true,
            applicationIcon: Container(
              height: 80,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset('images/icons/logo.png'),
                ),
              ),
            ),
            applicationName: 'iFIN',
            applicationVersion: '0.5.0 (beta)',
            applicationLegalese: '© 2020 iFIN Private Ltd.',
            child: new ListTile(
              leading: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: '',
                  style: TextStyle(
                    color: CustomColors.mfinLightBlue,
                    fontFamily: 'Georgia',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'i',
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              // topRight
                              offset: Offset(0.5, 0.5),
                              color: CustomColors.mfinWhite),
                          Shadow(
                              // topLeft
                              offset: Offset(-0.5, 0.5),
                              color: CustomColors.mfinWhite),
                        ],
                        color: CustomColors.mfinBlue,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'FIN',
                      style: TextStyle(
                        color: CustomColors.mfinButtonGreen,
                        fontFamily: 'Georgia',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: 'v0.5.0',
                  style: TextStyle(
                    color: CustomColors.mfinButtonGreen,
                    fontFamily: 'Georgia',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' (Beta)',
                      style: TextStyle(
                        color: CustomColors.mfinGrey,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            aboutBoxChildren: <Widget>[
              SizedBox(
                height: 20,
              ),
              Divider(),
              ListTile(
                leading: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'i',
                    style: TextStyle(
                      color: CustomColors.mfinBlue,
                      fontFamily: 'Georgia',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'FIN',
                        style: TextStyle(
                          color: CustomColors.mfinButtonGreen,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                title: RichText(
                  text: TextSpan(
                    text: 'Built For Micro Finance Industry Network ',
                    style: TextStyle(
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '(MFIN)',
                        style: TextStyle(
                          color: CustomColors.mfinButtonGreen,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: CustomColors.mfinBlue,
                  size: 35.0,
                ),
                title: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    color: CustomColors.mfinLightBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
            ],
          ),
        ),
      ],
    ),
  );
}
