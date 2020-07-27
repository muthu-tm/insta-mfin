import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instamfin/screens/home/AuthPage.dart';
import 'package:instamfin/screens/utils/CustomColors.dart';
import 'package:instamfin/services/analytics/analytics.dart';
import 'package:instamfin/services/controllers/user/user_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:instamfin/app_localizations.dart';

void main() {
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhia31ifWN9Z2FoYmF8YGJ8ampqanNiYmlmamlmanMDHmg+Jic7JmBgMCA2EzQ+Mjo/fTA8Pg==");
  runApp(MyApp());
  setupLocator();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType();
    
    state.setState(() {
      state.locale = newLocale;
    }); 
  }
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  
  Locale locale;

  @override
  void initState() {
    super.initState();
    this.locale = locale;
  }

  @override
  Widget build(BuildContext context) {
    Analytics.setupAnalytics(analytics, observer);
    return MaterialApp(
      locale: this.locale,
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
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ta', 'IN'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      navigatorObservers: <NavigatorObserver>[observer],
      home: AuthPage(),
    );
  }

  // _fetchLocale() async {
  //   final User _user = UserController().getCurrentUser();
  //   if(_user != null){
  //     var selectedLanguage = _user.preferences.prefLanguage;
  //     if(selectedLanguage == "Tamil"){
  //       return Locale('ta', 'IN');
  //     }else{
  //       Locale('en', 'US');
  //     }
  //   }
  // }
}
