import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmg+Jic7JmBgMCA2EzQ+Mjo/fTA8Pg==");
  runApp(MyApp());
  setupLocator();
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    Analytics.setupAnalytics(analytics, observer);
    return MaterialApp(
      title: 'iFIN',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Hind',
            color: CustomColors.mfinWhite,
          ),
        ),
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: AuthPage(),
    );
  }
}
