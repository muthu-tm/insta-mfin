import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/support/UserActionSupport.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help & Support"),
        backgroundColor: CustomColors.mfinBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.verified_user, color: CustomColors.mfinBlue),
              title: Text(
                "User - Signup, Login & Logout",
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserActionSupport(),
                    settings: RouteSettings(name: '/settings/app/support/user'),
                  ),
                );
              },
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              title: Text(
                "Transactions",
              ),
              leading: Icon(Icons.content_copy, color: CustomColors.mfinBlue),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Notebooks",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         BooksHome(cachedLocalUser.accPreferences.chitEnabled),
                  //     settings: RouteSettings(name: '/transactions/books'),
                  //   ),
                  // ),
                ),
                ListTile(
                  title: Text(
                    "Expenses",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ExpenseHome(),
                  //     settings: RouteSettings(name: '/transactions/expenses'),
                  //   ),
                  // ),
                ),
                ListTile(
                  title: Text(
                    "Journals",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => JournalEntryHome(),
                  //     settings: RouteSettings(name: '/transactions/journals'),
                  //   ),
                  // ),
                ),
                ListTile(
                  title: Text('Configurations'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TransactionConfigHome(),
                  //     settings: RouteSettings(name: '/transactions/config'),
                  //   ),
                  // ),
                ),
              ],
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              leading:
                  Icon(Icons.supervisor_account, color: CustomColors.mfinBlue),
              title: Text(
                "Customers",
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Add Loan",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AddCustomer(),
                  //     settings: RouteSettings(name: '/customers/add'),
                  //   ),
                  // ),
                ),
                ListTile(
                  title: Text(
                    "Add Collection",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CustomersHome(),
                  //     settings: RouteSettings(name: '/customers'),
                  //   ),
                  // ),
                ),
              ],
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              leading: Icon(Icons.local_florist, color: CustomColors.mfinBlue),
              title: Text(
                "Chit Fund",
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Add Chit",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AddCustomer(),
                  //     settings: RouteSettings(name: '/customers/add'),
                  //   ),
                  // ),
                ),
                ListTile(
                  title: Text(
                    "Allocate Chit",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CustomersHome(),
                  //     settings: RouteSettings(name: '/customers'),
                  //   ),
                  // ),
                ),
              ],
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading: Icon(Icons.description, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Reports",
              ),
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ReportsHome(),
              //     settings: RouteSettings(name: '/reports'),
              //   ),
              // ),
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading: Icon(Icons.assessment, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Statistics",
              ),
              // onTap: () => Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => StatisticsHome(),
              //     settings: RouteSettings(name: '/statistics'),
              //   ),
              // ),
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading: Icon(Icons.dashboard, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Dashboard Details",
              ),
              // onTap: () =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => NotificationHome(),
              //       settings: RouteSettings(name: '/notifications'),
              //     ),
              //   ),
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading:
                  Icon(Icons.account_balance, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Finance",
              ),
              // onTap: () =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => FinanceSetting(),
              //       settings: RouteSettings(name: '/settings/finance'),
              //     ),
              //   )
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading: Icon(Icons.settings, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "User Settings",
              ),
              // onTap: () =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => UserSetting(),
              //       settings: RouteSettings(name: '/settings/user'),
              //     ),
              //   )
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading: Icon(Icons.palette, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Preferences",
              ),
              // onTap: () =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => UserSetting(),
              //       settings: RouteSettings(name: '/settings/user'),
              //     ),
              //   )
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ListTile(
              leading:
                  Icon(Icons.monetization_on, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Subscription",
              ),
              // onTap: () =>
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => UserSetting(),
              //       settings: RouteSettings(name: '/settings/user'),
              //     ),
              //   )
            ),
            Divider(
              indent: 75.0,
              color: CustomColors.mfinGrey,
              height: 0,
              thickness: 1.0,
            ),
            ListTile(
              leading: Icon(Icons.headset_mic, color: CustomColors.mfinBlue),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                "Contact Us",
              ),
              onTap: () => showDialog(
                context: context,
                routeSettings: RouteSettings(name: "/home/help"),
                builder: (context) {
                  return Center(
                    child: contactAndSupportDialog(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
