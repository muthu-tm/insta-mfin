import 'package:flutter/material.dart';
import 'package:instamfin/db/models/user.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/app/NotificationHome.dart';
import 'package:instamfin/screens/app/ProfilePictureUpload.dart';
import 'package:instamfin/screens/chit/ChitHome.dart';
import 'package:instamfin/screens/customer/AddCustomer.dart';
import 'package:instamfin/screens/customer/CustomersHome.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/home/UserFinanceSetup.dart';
import 'package:instamfin/screens/reports/ReportsHome.dart';
import 'package:instamfin/screens/settings/FinanceSetting.dart';
import 'package:instamfin/screens/settings/UserSetting.dart';
import 'package:instamfin/screens/statistics/StatisticsHome.dart';
import 'package:instamfin/screens/transaction/ExpenseHome.dart';
import 'package:instamfin/screens/transaction/JournalEntryHome.dart';
import 'package:instamfin/screens/transaction/books/BooksHome.dart';
import 'package:instamfin/screens/transaction/configuration/TransactionConfigHome.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/screens/utils/CustomDialogs.dart';
import 'package:instamfin/services/controllers/auth/auth_controller.dart';
import 'package:instamfin/services/controllers/user/user_controller.dart';

Widget openDrawer(BuildContext context) {
  final User _user = UserController().getCurrentUser();
  final AuthController _authController = AuthController();

  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: CustomColors.mfinBlue,
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: _user.getProfilePicPath() == ""
                    ? Container(
                        width: 90,
                        height: 90,
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CustomColors.mfinFadedButtonGreen,
                            style: BorderStyle.solid,
                            width: 2.0,
                          ),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              routeSettings:
                                  RouteSettings(name: "/profile/upload"),
                              builder: (context) {
                                return Center(
                                  child: ProfilePictureUpload(
                                      0,
                                      _user.getProfilePicPath(),
                                      _user.mobileNumber.toString(),
                                      _user.mobileNumber),
                                );
                              },
                            );
                          },
                          child: Text(
                            "Upload",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.mfinLightGrey,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage:
                                  NetworkImage(_user.getProfilePicPath()),
                              backgroundColor: Colors.transparent,
                            ),
                            Positioned(
                              bottom: -5,
                              left: 30,
                              child: FlatButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    routeSettings:
                                        RouteSettings(name: "/profile/upload"),
                                    builder: (context) {
                                      return Center(
                                        child: ProfilePictureUpload(
                                            0,
                                            _user.getProfilePicPath(),
                                            _user.mobileNumber.toString(),
                                            _user.mobileNumber),
                                      );
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: CustomColors.mfinButtonGreen,
                                  radius: 15,
                                  child: Icon(
                                    Icons.edit,
                                    color: CustomColors.mfinWhite,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
        ListTile(
            leading: Icon(Icons.home, color: CustomColors.mfinButtonGreen),
            title: Text('Home'),
            onTap: () async {
              await UserController().refreshUser(false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => UserFinanceSetup(),
                  settings: RouteSettings(name: '/home'),
                ),
                (Route<dynamic> route) => false,
              );
            }),
        Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        ExpansionTile(
          title: Text("Transactions"),
          leading:
              Icon(Icons.content_copy, color: CustomColors.mfinButtonGreen),
          children: <Widget>[
            ListTile(
              title: Text('My NoteBooks'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BooksHome(),
                  settings: RouteSettings(name: '/transactions/books'),
                ),
              ),
            ),
            ListTile(
              title: Text('Expenses'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseHome(),
                  settings: RouteSettings(name: '/transactions/expenses'),
                ),
              ),
            ),
            ListTile(
              title: Text('Journals'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEntryHome(),
                  settings: RouteSettings(name: '/transactions/journals'),
                ),
              ),
            ),
            ListTile(
              title: Text('Configurations'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionConfigHome(),
                  settings: RouteSettings(name: '/transactions/config'),
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.supervisor_account,
              color: CustomColors.mfinButtonGreen),
          title: Text('My Customers'),
          children: <Widget>[
            ListTile(
              title: Text('Add a Customer'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomer(),
                  settings: RouteSettings(name: '/customers/add'),
                ),
              ),
            ),
            ListTile(
              title: Text('View Customers'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomersHome(),
                  settings: RouteSettings(name: '/customers'),
                ),
                (Route<dynamic> route) => false,
              ),
            ),
          ],
        ),
        _user.accPreferences.chitEnabled
            ? ListTile(
                leading: Icon(Icons.transfer_within_a_station,
                    color: CustomColors.mfinButtonGreen),
                title: Text('Chit Fund'),
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChitHome(),
                    settings: RouteSettings(name: '/chit'),
                  ),
                  (Route<dynamic> route) => false,
                ),
              )
            : ListTile(
                leading: Icon(Icons.transfer_within_a_station,
                    color: CustomColors.mfinGrey),
                title: Text('Chit Fund'),
                onTap: () {}),
        ListTile(
          leading: Icon(Icons.description, color: CustomColors.mfinButtonGreen),
          title: Text('Reports'),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ReportsHome(),
              settings: RouteSettings(name: '/reports'),
            ),
            (Route<dynamic> route) => false,
          ),
        ),
        ListTile(
          leading: Icon(Icons.assessment, color: CustomColors.mfinButtonGreen),
          title: Text('Statistics'),
          onTap: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => StatisticsHome(),
              settings: RouteSettings(name: '/statistics'),
            ),
            (Route<dynamic> route) => false,
          ),
        ),
        Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        ListTile(
          leading: Icon(Icons.notifications_active,
              color: CustomColors.mfinButtonGreen),
          title: Text('Notifications'),
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
        Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        ListTile(
          leading:
              Icon(Icons.account_balance, color: CustomColors.mfinButtonGreen),
          title: Text('Finance Settings'),
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
        ListTile(
          leading: Icon(Icons.settings, color: CustomColors.mfinButtonGreen),
          title: Text('Profile Settings'),
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
        Divider(indent: 15.0, color: CustomColors.mfinBlue, thickness: 1.0),
        ListTile(
          leading: Icon(Icons.headset_mic, color: CustomColors.mfinButtonGreen),
          title: Text('Help & Support'),
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
        ListTile(
          leading: Icon(Icons.error, color: CustomColors.mfinAlertRed),
          title: Text('Logout'),
          onTap: () => CustomDialogs.confirm(
              context, "Warning!", "Do you really want to Logout?", () async {
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
            child: ListTile(
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
                        color: CustomColors.mfinFadedButtonGreen,
                        fontFamily: 'Georgia',
                        fontSize: 16.0,
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
