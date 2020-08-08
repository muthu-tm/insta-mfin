import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Analytics {
  static FirebaseAnalytics analytics;
  static FirebaseAnalyticsObserver observer;

  static setupAnalytics(
      FirebaseAnalytics analytics, FirebaseAnalyticsObserver observer) {
    Analytics.analytics = analytics;
    Analytics.observer = observer;
  }

  static Future<void> sendAnalyticsEvent(
      Map<String, dynamic> data, String name) async {
    await analytics.logEvent(
      name: name,
      parameters: data,
    );
  }

  static Future loginEvent(String userID) async {
    await analytics.setUserId(userID);
    await analytics.logLogin(loginMethod: 'Mobile');
  }

  static Future signupEvent(String userId) async {
    await analytics.logSignUp(signUpMethod: 'Mobile');
    await analytics.setUserId(userId);
  }

  static Future reportError(Map<String, dynamic> data, String eventName) async {
    await analytics.logEvent(name: eventName, parameters: data);
  }

  static Future<void> setAnalyticsCollectionEnabled(bool isEnabled) async {
    await analytics.setAnalyticsCollectionEnabled(isEnabled);
  }

  static Future<void> setUserProperty(String name, String value) async {
    await analytics.setUserProperty(name: name, value: value);
  }
}
