import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:instamfin/screens/home/Authenticate.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  runApp(MyApp());
  setupLocator();
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Analytics.setupAnalytics(analytics, observer);
    return MaterialApp(
      title: 'iFIN',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        // Define the default font family.
        fontFamily: 'Georgia',
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
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
      home: Authenticate(),
    );
  }
}
