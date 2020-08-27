import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:instamfin/services/utils/hash_generator.dart';
import '../../app_localizations.dart';

Widget openDrawer(BuildContext context) {
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
                child: cachedLocalUser.getProfilePicPath() == ""
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
                                      cachedLocalUser.getMediumProfilePicPath(),
                                      HashGenerator.hmacGenerator(
                                          cachedLocalUser.getID(),
                                          cachedLocalUser
                                              .createdAt.millisecondsSinceEpoch
                                              .toString()),
                                      cachedLocalUser.getIntID()),
                                );
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.person,
                                  size: 45.0,
                                  color: CustomColors.mfinLightGrey,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('upload'),
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: CustomColors.mfinLightGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              width: 95.0,
                              height: 95.0,
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      cachedLocalUser.getMediumProfilePicPath(),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage: imageProvider,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    size: 35,
                                  ),
                                  fadeOutDuration: Duration(seconds: 1),
                                  fadeInDuration: Duration(seconds: 2),
                                ),
                              ),
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
                                            cachedLocalUser
                                                .getMediumProfilePicPath(),
                                            HashGenerator.hmacGenerator(
                                                cachedLocalUser.getID(),
                                                cachedLocalUser.createdAt
                                                    .millisecondsSinceEpoch
                                                    .toString()),
                                            cachedLocalUser.getIntID()),
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
                cachedLocalUser.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: CustomColors.mfinLightGrey,
                ),
              ),
              Text(
                cachedLocalUser.mobileNumber.toString(),
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
            title: Text(
              AppLocalizations.of(context).translate('home'),
            ),
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
          title: Text(
            AppLocalizations.of(context).translate('transactions'),
          ),
          leading:
              Icon(Icons.content_copy, color: CustomColors.mfinButtonGreen),
          children: <Widget>[
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate('my_notebooks'),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BooksHome(cachedLocalUser.accPreferences.chitEnabled),
                  settings: RouteSettings(name: '/transactions/books'),
                ),
              ),
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate('expenses'),
              ),
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
              title: Text(
                AppLocalizations.of(context).translate('journals'),
              ),
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
          title: Text(
            AppLocalizations.of(context).translate('my_customers'),
          ),
          children: <Widget>[
            ListTile(
              title: Text(
                AppLocalizations.of(context).translate('add_a_customer'),
              ),
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
              title: Text(
                AppLocalizations.of(context).translate('view_customers'),
              ),
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
        cachedLocalUser.accPreferences.chitEnabled
            ? ListTile(
                leading: Icon(Icons.local_florist,
                    color: CustomColors.mfinButtonGreen),
                title:
                    Text(AppLocalizations.of(context).translate('chit_fund')),
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
                leading:
                    Icon(Icons.local_florist, color: CustomColors.mfinGrey),
                title: Text(
                  AppLocalizations.of(context).translate('chit_fund'),
                ),
                onTap: () {}),
        ListTile(
          leading: Icon(Icons.description, color: CustomColors.mfinButtonGreen),
          title: Text(
            AppLocalizations.of(context).translate('reports'),
          ),
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
          title: Text(
            AppLocalizations.of(context).translate('statistics'),
          ),
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
          title: Text(
            AppLocalizations.of(context).translate('notifications'),
          ),
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
          title: Text(
            AppLocalizations.of(context).translate('finance_settings'),
          ),
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
          title: Text(
            AppLocalizations.of(context).translate('profile_settings'),
          ),
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
          title: Text(
            AppLocalizations.of(context).translate('help_and_support'),
          ),
          onTap: () {
            showDialog(
              context: context,
              routeSettings: RouteSettings(name: "/home/help"),
              builder: (context) {
                return Center(
                  child: contactAndSupportDialog(context),
                );
              },
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.error, color: CustomColors.mfinAlertRed),
          title: Text(
            AppLocalizations.of(context).translate('logout'),
          ),
          onTap: () => CustomDialogs.confirm(
              context,
              AppLocalizations.of(context).translate('warning'),
              AppLocalizations.of(context).translate('logout_message'),
              () async {
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
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/icons/logo.png',
                    height: 60,
                    width: 60,
                  ),
                ),
              ),
            ),
            applicationName: 'mFIN',
            applicationLegalese:
                AppLocalizations.of(context).translate('copyright'),
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
                      text: 'm',
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
                    text: 'm',
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
                    text: AppLocalizations.of(context).translate('company_tag'),
                    style: TextStyle(
                      color: CustomColors.mfinPositiveGreen,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('micro_company'),
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
                  AppLocalizations.of(context)
                      .translate('terms_and_conditions'),
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
