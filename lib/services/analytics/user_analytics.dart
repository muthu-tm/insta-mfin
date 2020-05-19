import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class UserAnalytics {
  static FirebaseAnalytics analytics;
  static FirebaseAnalyticsObserver observer;

  static setupAnalytics(
      FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer) {
    UserAnalytics.analytics = analytics;
    UserAnalytics.observer = observer;
  }

  static Future<void> sendAnalyticsEvent(String name, Map<String, dynamic> data) async {
    await analytics.logEvent(
      name: name,
      parameters: data,
    );
    print('updated $name analytics');
  }

  static Future loginEvent(String userID) async {
    await analytics.setUserId(userID);
    await analytics.logLogin(loginMethod: 'mobile');
  }

  static Future signupEvent(String userId) async {
    await analytics.logSignUp(signUpMethod: 'Mobile');
    await analytics.setUserId(userId);
  }

  static Future reportError(Map<String, dynamic> data) async {
    await analytics.logEvent(name: 'Error', parameters: data);
  }
  
  // static Future<void> setUserId(String userID) async {
  //   await analytics.setUserId(userID);
  // }

  static Future<void> setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
  }

  static Future<void> setAnalyticsCollectionEnabled() async {
    await analytics.setAnalyticsCollectionEnabled(false);
    await analytics.setAnalyticsCollectionEnabled(true);
  }

  static Future<void> setUserProperty() async {
    await analytics.setUserProperty(name: 'regular', value: 'indeed');
  }

}
