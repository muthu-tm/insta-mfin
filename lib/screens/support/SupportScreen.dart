import 'package:flutter/material.dart';
import 'package:instamfin/screens/app/ContactAndSupportWidget.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';

import 'BooksSupport.dart';
import 'DashboardSupport.dart';
import 'DeactivateSupport.dart';
import 'ProfileSupport.dart';
import 'RemoveFinanceUserSupport.dart';
import 'ReportsSupport.dart';
import 'UserActionSupport.dart';
import 'AddFinanceUserSupport.dart';
import 'DeactivateFinanceSupport.dart';
import 'FinancePrefSupport.dart';
import 'FinanceSupport.dart';
import 'ManageBranchSupport.dart';
import 'PrimaryFinanceSupport.dart';
import 'StatisticsSupport.dart';
import 'UserPrefSupport.dart';

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
                "User - Signup & Login",
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
              title: Text("Finance"),
              leading: Icon(Icons.settings, color: CustomColors.mfinBlue),
              children: [
                ListTile(
                  title: Text(
                    "Edit Finance Details",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinanceSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/edit'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Manage Branch/Sub-Branch",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageBranchSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/manage'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Deactivate Finance/Branch/Sub-Branch",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeactivateFinanceSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/deactivate'),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              title: Text("Finance User/Agent"),
              leading: Icon(Icons.group, color: CustomColors.mfinBlue),
              children: [
                ListTile(
                  title: Text(
                    "Add User",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFinanceUserSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/user/add'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Remove User",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddFinanceUserSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/user/remove'),
                    ),
                  ),
                ),
              ],
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
              onTap: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardSupport(),
                    settings: RouteSettings(name: '/dashboard'),
                  ),
                ),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BooksSupport(),
                      settings:
                          RouteSettings(name: '/settings/app/support/books'),
                    ),
                  ),
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
                "Loan & Collections",
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportsSupport(),
                  settings:
                      RouteSettings(name: '/settings/app/support/reports'),
                ),
              ),
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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsSupport(),
                  settings:
                      RouteSettings(name: '/settings/app/support/statistics'),
                ),
              ),
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              title: Text("User Settings"),
              leading: Icon(Icons.settings, color: CustomColors.mfinBlue),
              children: [
                ListTile(
                  title: Text(
                    "Edit Primary Finance",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrimaryFinanceSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/primary/edit'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Edit Profile",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/profile/edit'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Deactivate Account",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeactivateSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/profile/deactivate'),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
                indent: 75.0,
                color: CustomColors.mfinGrey,
                height: 0,
                thickness: 1.0),
            ExpansionTile(
              title: Text("Preferences"),
              leading: Icon(Icons.palette, color: CustomColors.mfinBlue),
              children: [
                ListTile(
                  title: Text(
                    "Finance Preferences",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinancePrefSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/finance/preferences'),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    "User Preferences",
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPrefSupport(),
                      settings: RouteSettings(
                          name: '/settings/app/support/user/preferences'),
                    ),
                  ),
                ),
              ],
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
